import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root

    property string address;

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    width: 800
    height: 600

    modal: true
    title: 'Export data'
    standardButtons: Dialog.Ok | Dialog.Close

    parent: ApplicationWindow.overlay

    onAccepted: {
        console.log('accepted')
        let exportCriteria = exportForm.criteria()
        console.log('time to send export request with', JSON.stringify(exportCriteria))
    }

    ExportForm{
        id: exportForm
        anchors.fill: parent
    }

}
