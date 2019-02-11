import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3

Dialog {

    id: root

    x: Math.floor((mainApp.width - width) / 2)
    y: Math.floor((mainApp.height - height) / 2)

    width: 600
    height: 300

    modal: true
    title: 'Upload data'
    standardButtons: Dialog.Close

    parent: ApplicationWindow.overlay

    UploadForm{
        address: 'http://localhost/put' // TODO: Fix this address with proper one
        token: 'my-magic-token' // TODO: Fix this token with proper one
        anchors.fill: parent

        id: upload_form
    }
}
