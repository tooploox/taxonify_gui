import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root

    property string address;
    property alias token : uploadForm.token

    readonly property alias uploadProgress : uploadForm.uploadProgress

    signal success(string replyData)
    signal error(string errorMsg)
    signal uploadStarted()
    signal uploadDetailsRequested(string upload_id)

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    readonly property int uploadListDialogHeight: 400

    width: 600
    height: 200

    modal: true
    title: 'Upload data'

    parent: ApplicationWindow.overlay

    function showUploadDetails(details) {
        uploadDetailsDialog.details = details
        uploadDetailsDialog.open()
    }

    contentItem: UploadForm{
        id: uploadForm
        address: root.address + '/upload'
        token: dataAccess.internal.access_token
        onSuccess: root.success(replyData)
        onError: root.error(errorMsg)
        onUploadStarted: root.uploadStarted()
    }

    footer: DialogButtonBox {
        Layout.alignment: Qt.AlignBottom | Qt.AlignRight

        onReset: uploadListDialog.open()
        onRejected: root.close()

        Button {
            text: qsTr("Upload List")
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

    UploadListDialog {
        id: uploadListDialog
        width: root.width; height: uploadListDialogHeight
        anchors.centerIn: parent

        onUploadDetailsRequested: root.uploadDetailsRequested(upload_id)
    }

    UploadDetailsDialog {
        id: uploadDetailsDialog
        width: root.width
        anchors.centerIn: parent

        // trick to provide proper display
        onAboutToShow: {
            uploadListDialog.height = height
        }
        onAboutToHide: {
            uploadListDialog.height = uploadListDialogHeight
        }
    }

}
