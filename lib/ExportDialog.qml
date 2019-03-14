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

    signal userListRequested()

    property alias exportCriteria: exportForm.exportCriteria

    function updateUserList(data) {
        console.debug(Logger.log, "")
        exportForm.updateUserList(data)
    }

    function processExportResponse(success, response) {
        console.debug(Logger.log, "success='" + JSON.stringify(success) + "', " +
                                  "response='" + JSON.stringify(response) + "'")
        busyIndication.running = false
        okButton.enabled = true
        if (!visible) {
            return
        }

        if (success) {
            console.debug(Logger.log, "processExportResponse succeeded")
            if (response.status === 'ok') {
                Qt.openUrlExternally(response.url)
                resultDialog.title = 'Data exported successfully\nwith your internet browser!'
                resultDialog.closeOnOk = true
            } else if (response.status === 'empty') {
                resultDialog.title = 'Nothing to export. No data matches\ngiven criteria.'
                resultDialog.closeOnOk = false
            }
        } else {
            console.debug(Logger.log, "processExportResponse failed")
            resultDialog.title = 'An error occurred during data export.'
            resultDialog.closeOnOk = false
        }
        resultDialog.open()
    }

    Dialog {
        id: resultDialog
        x: Math.floor((parent.width - width) / 2)
        y: Math.floor((parent.height - height) / 2)
        width: 400
        height: 100
        modal: true
        standardButtons: Dialog.Ok

        property bool closeOnOk: true
        onAccepted: {
            console.debug(Logger.log, "resultDialog")
            if (closeOnOk) {
                root.close()
            }
        }
    }

    ExportForm {
        id: exportForm
        anchors.fill: parent
        onUserListRequested: {
            console.debug(Logger.log, "ExportForm")
            root.userListRequested()
        }
    }

    footer: DialogButtonBox {
        Layout.alignment: Qt.AlignBottom | Qt.AlignRight
        onRejected: {
            console.debug(Logger.log, "DialogButtonBox")
            root.close()
        }

        Button {
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            text: qsTr("Cancel")
        }

        Button {
            id: okButton
            text: busyIndication.running ? "" : "Ok"

            indicator: Item {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                BusyIndicator {
                    id: busyIndication
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 30
                    height: 30
                    running: false
                }
            }

            onClicked: {
                console.debug(Logger.log, "okButton")
                accepted()
                busyIndication.running = !busyIndication.running
                enabled = false
            }
        }
    }
}
