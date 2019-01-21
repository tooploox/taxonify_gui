import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    id: selectionBox
    //color: 'red'

    border.color: 'lightgray'

    Layout.preferredWidth: 300
    Layout.fillHeight: true

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
                id: checkBox6
                checked: true
                text: qsTr("Taxonometry")
            }

            TaxonomyFilter {
                enabled: checkBox6.checked
            }
        }

        GroupBox {

            Layout.fillWidth: true

            label: CheckBox {
                id: checkBox4
                checked: true
                text: qsTr("Liveness")
            }

            ColumnLayout {
                anchors.fill: parent
                enabled: checkBox4.checked
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
