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

        GroupBox {
            Layout.fillWidth: true

            label: CheckBox {
                id: livenessCkbx
                checked: true
                text: qsTr("Liveness")
            }

            ColumnLayout {
                anchors.fill: parent
                enabled: livenessCkbx.checked
                CheckBox { text: qsTr("Alive") }
                CheckBox { text: qsTr("Dead") }
                CheckBox { text: qsTr("Not specified") }
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
