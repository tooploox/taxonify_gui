import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Dialog {
    readonly property alias uploadProgress : uploadForm.uploadProgress
    id: root

    signal success(string replyData)
    signal error(string errorMsg)
    signal uploadStarted()

    x: Math.floor((mainApp.width - width) / 2)
    y: Math.floor((mainApp.height - height) / 2)

    width: 600
    height: 250

    modal: true
    title: 'Upload data'
    standardButtons: Dialog.Close

    parent: ApplicationWindow.overlay

    UploadForm{
        id: uploadForm
        address: getSettingVariable('host')+'/upload'
        token: 'my-magic-token' // TODO: Fix this token with proper one
        anchors.fill: parent
        onSuccess: root.success(replyData)
        onError: root.error(errorMsg)
        onUploadStarted: root.uploadStarted()
    }
}
