import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


import "qrc:/network"

Dialog {
    id: root

    modal: true
    title: 'Uploaded files: ' + uploadList.uploadData.count

    parent: ApplicationWindow.overlay

    contentItem: UploadList {
        id: uploadList
    }

    footer: DialogButtonBox {
        Layout.alignment: Qt.AlignBottom | Qt.AlignRight

        onReset: {
            Logger.log("UploadListDialog: reset")
            uploadListReq.call()
        }

        onRejected: {
            Logger.log("UploadListDialog: rejected")
            root.close()
        }

        Button {
            text: qsTr("Refresh")
            DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
            Material.primary: Material.Grey
            Material.background: Material.background
        }
        Button {
            text: qsTr("Close")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            Material.primary: Material.Grey
            Material.background: Material.background
        }
    }

    onAboutToShow: {
        Logger.log("UploadListDialog: about to show")
        uploadListReq.call()
    }

    Request{
        id: uploadListReq
        handler: dataAccess.uploadList

        onSuccess: {
            Logger.log("UploadListDialog: uploadListReq succeeded")
            uploadList.setData(res)
        }

        onError: {
            Logger.log("UploadListDialog: uploadListReq failed")
            console.log("Failed to get upload list! Details: " + details)
        }
    }
}
