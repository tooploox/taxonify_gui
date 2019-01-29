import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    ColumnLayout {
        width: parent.width

        ButtonGroup { id: radioGroup }

        Label {
            Layout.fillWidth: true
            text: "Annotation"
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
        }

        GroupBox {
            Layout.fillWidth: true

            label: RadioButton {
                id: taxonomyRbtn
                text: qsTr("Taxonomy")
                ButtonGroup.group: radioGroup
            }

            TaxonomyFilter {
                enabled: taxonomyRbtn.checked
            }
        }

        GroupBox {
            Layout.fillWidth: true

            label: RadioButton {
                id: livenessRbtn
                checked: true
                text: qsTr("Liveness")
                ButtonGroup.group: radioGroup
            }

            LivenessFilter {
                enabled: livenessRbtn.checked
                isAnnotationMode: true
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }


        Button {
            text: 'Apply to selected images'

            Layout.alignment: Qt.AlignCenter
        }
    }
}
