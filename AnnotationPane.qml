import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    ColumnLayout {
        width: parent.width

        Label {
            Layout.fillWidth: true
            text: "Annotation"
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
        }

        GroupBox {
            Layout.fillWidth: true

            label: CheckBox {
                id: taxonomyCkbx
                checked: true
                text: qsTr("Taxonomy")
            }

            TaxonomyFilter {
                enabled: taxonomyCkbx.checked
            }
        }

        LivenessGroupBox  {}

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
