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

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    width: 600
    height: 600

    modal: true
    title: 'Export data'
    standardButtons: Dialog.Close

    parent: ApplicationWindow.overlay

    UploadForm{
        id: uploadForm
        anchors.fill: parent
        address: root.address + '/upload'
        token: dataAccess.internal.access_token
        onSuccess: root.success(replyData)
        onError: root.error(errorMsg)
        onUploadStarted: root.uploadStarted()
    }

}
