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

    signal uploadDetailsRequested(string upload_id)

    contentItem: UploadList {
        id: uploadList
        onUploadDetailsRequested: root.uploadDetailsRequested(upload_id)
    }

    footer: DialogButtonBox {
        Layout.alignment: Qt.AlignBottom | Qt.AlignRight

        onReset: uploadListReq.call()
        onRejected: root.close()

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

    onAboutToShow: uploadListReq.call()

    Request{
        id: uploadListReq
        handler: dataAccess.uploadList

        onSuccess: uploadList.setData(res)
        onError: console.log("Failed to get upload list! Details: " + details)
    }
}
