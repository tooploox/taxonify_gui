import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: filterDialog
    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)
    width: 600
    height: 600

    modal: true
    title: 'Choose properties'
    parent: ApplicationWindow.overlay

    standardButtons: Dialog.Ok
    onAccepted: close()

    function pickedAttributes() {
        return picker.pickedAttributes()
    }

    ImageDetailsPicker {
        id: picker
        anchors.fill: parent
    }
}
