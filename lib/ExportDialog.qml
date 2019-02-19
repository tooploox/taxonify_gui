import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root

    property string address;

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    width: 600
    height: 600

    modal: true
    title: 'Export data'
    standardButtons: Dialog.Close

    parent: ApplicationWindow.overlay

    ExportForm{
        id: exporForm
        anchors.fill: parent
    }

}
