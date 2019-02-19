import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    property var criteria: {
        if(taxonomyRbtn.checked)
            return taxonomyfltr.criteria

        if(livenessRbtn.checked)
            return livenessfltr.criteria

        return { dummyExclusive: true }
    }

    signal applyClicked()

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

                RadioButton {
                    id: livenessRbtn
                    checked: false
                    text: qsTr("Liveness")
                    ButtonGroup.group: radioGroup
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
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

                        LivenessFilter {
                            id: livenessfltr
                            enabled: livenessRbtn.checked
                            visible: livenessRbtn.checked
                            annotationMode: true
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
