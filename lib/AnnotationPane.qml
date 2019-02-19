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

    property var attributes: ['with_eggs', 'dividing', 'dead', 'with_epibiont', 'with_parasite', 'broken',
        'colony', 'cluster', 'eating', 'multiple_species', 'partially_cropped', 'male',
        'female', 'juvenile', 'adult', 'ephippium', 'resting_egg', 'heterocyst', 'akinete',
        'with_spines', 'beatles', 'stones', 'zeppelin', 'floyd', 'acdc', 'hendrix',
        'alan_parsons', 'allman', 'dire_straits', 'eagles', 'guns', 'purple', 'van_halen',
        'skynyrd', 'zz_top', 'iron', 'police', 'moore', 'inxs', 'chilli_peppers']

    property var checkedAttrIdx: null

    ColumnLayout {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Annotation")
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
        }

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
                        text: modelData
                        ButtonGroup.group: radioGroup

                        onClicked: {
                            checkedAttrIdx = index
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: parent.height - 100
            clip: true
            contentWidth: width

            ColumnLayout {
                width: parent.width

                GroupBox {
                    Layout.fillWidth: true

                    Column {
                        anchors.fill: parent

                        TaxonomyFilter {
                            id: taxonomyfltr
                            annotationMode: true
                            enabled: taxonomyRbtn.checked
                            visible: taxonomyRbtn.checked
                            width: parent.width
                        }

                        Repeater {
                            id: attributefltrs
                            model: attributes

                            AttributeFilter {
                                attributeName: modelData
                                enabled: checked
                                visible: checked
                                annotationMode: true

                                property bool checked: index < attributesRbtns.count ? attributesRbtns.itemAt(index).checked : false
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
