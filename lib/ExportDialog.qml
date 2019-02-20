import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root
    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    width: 800
    height: 600

    modal: true
    title: 'Export data'

    parent: ApplicationWindow.overlay

    property alias exportCriteria: exportForm.exportCriteria

    function processExportResponse(response) {
        busyIndication.running = false
        okButton.enabled = true
        if (!visible) {
            return
        }
        console.log('response received', JSON.stringify(response, null, 2))

        Qt.openUrlExternally(response.url)
        close()
    }

    ExportForm {
        id: exportForm
        anchors.fill: parent
    }

    footer: DialogButtonBox {
        Layout.alignment: Qt.AlignBottom | Qt.AlignRight
        onRejected: root.close()

        Button {
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            text: qsTr("Cancel")
        }

        Button {
            id: okButton
            property string prefix: busyIndication.running ? "        " : ""
            text: prefix + "Ok"

            indicator: Item {
                anchors.verticalCenter: parent.verticalCenter
                BusyIndicator {
                    id: busyIndication
                    anchors.verticalCenter: parent.verticalCenter
                    width: 30
                    height: 30
                    running: false
                }
            }

            onClicked: {
                accepted()
                busyIndication.running = !busyIndication.running
                enabled = false
            }
        }
    }
}
