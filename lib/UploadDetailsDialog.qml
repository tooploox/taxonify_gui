import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Dialog {
    id: root

    modal: true
    parent: ApplicationWindow.overlay
    property var details

    height: details.duplicate_filenames === undefined ? 200 : 500

    title: 'Upload: ' + details.filename

    function detailsText() {
        let text = ''
        text += 'Name: ' + details.filename + '<br>'
        text += 'State: ' + details.state + '<br>'

        text += 'Image count: '
        if (details.image_count === undefined) {
            text += '-'
        } else {
            text += details.image_count
        }
        text += '<br>'

        text += 'Duplicate image count: '
        if (details.duplicate_image_count === undefined) {
            text += '-'
        } else {
            text += details.duplicate_image_count
        }
        text += '<br>'

        return text
    }

    contentItem: ColumnLayout {
        Label {
            text: detailsText()
        }

        Label {
            id: dupLabel
            text: 'Duplicate filenames:'
            visible: details.duplicate_filenames !== undefined
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: details.duplicate_filenames !== undefined
            clip: true

            TextArea {
                readOnly: true
                clip: true
                text: JSON.stringify(details.duplicate_filenames, null, 2)
                background: Rectangle {
                    color: 'whitesmoke'
                }
            }
        }
    }

    standardButtons: Dialog.Ok

}
