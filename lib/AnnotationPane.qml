import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    property var criteria: {
        if(taxonomyRbtn.checked)
            return taxonomyfltr.criteria

        if (checkedAttrIdx !== null)
            return attributefltrs.itemAt(checkedAttrIdx).criteria

        return { dummyExclusive: true }
    }

    signal applyClicked()

    readonly property var attributes: ItemAttributes.additionalAttributes
    property var checkedAttrIdx: null

    ColumnLayout {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: parent.height - 100
            clip: true
            contentWidth: width

            ColumnLayout {
                width: parent.width

                ButtonGroup { id: radioGroup }

                RadioButton {
                    id: taxonomyRbtn
                    checked: false
                    text: qsTr("Taxonomy")
                    ButtonGroup.group: radioGroup
                }

                Repeater {
                    id: attributesRbtns
                    model: attributes

                    RadioButton {
                        checked: false
                        text: preformatAttrName(modelData)
                        ButtonGroup.group: radioGroup

                        onClicked: {
                            checkedAttrIdx = index
                        }

                        function preformatAttrName(name) {
                            return (name.charAt(0).toUpperCase() + name.slice(1)).replace(/[_]/g, " ")
                        }
                    }
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: parent.height - 100
            Layout.minimumHeight: fltrsSubpane.height
            clip: true
            contentWidth: width

            ColumnLayout {
                id: fltrsSubpane
                width: parent.width

                GroupBox {
                    Layout.fillWidth: true

                    Column {
                        anchors.fill: parent

                        Text {
                            text: taxonomyRbtn.text
                            visible: taxonomyRbtn.checked
                            font.bold: true
                            height: 30
                        }

                        TaxonomyFilter {
                            id: taxonomyfltr
                            width: parent.width
                            annotationMode: true
                            enabled: taxonomyRbtn.checked
                            visible: taxonomyRbtn.checked
                        }

                        Repeater {
                            id: attributefltrs
                            model: attributes

                            Column {
                                id: col
                                property bool checked: index < attributesRbtns.count ? attributesRbtns.itemAt(index).checked : false
                                property string text: index < attributesRbtns.count ? attributesRbtns.itemAt(index).text : ''
                                property alias criteria: attrFltr.criteria

                                Text {
                                    text: col.text
                                    visible: col.checked
                                    font.bold: true
                                    height: 30
                                }

                                AttributeFilter {
                                    id: attrFltr
                                    attributeName: modelData
                                    enabled: col.checked
                                    visible: col.checked
                                    annotationMode: true
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Button {
            text: qsTr('Apply to selected images')
            enabled: radioGroup.checkState !== Qt.Unchecked
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter

            onClicked: applyClicked()
        }
    }
}
