import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Dialog {
    id: root

    modal: true
    parent: ApplicationWindow.overlay
    readonly property int listViewBorder: 3
    property var details: null

    height: details && details.duplicate_filenames === undefined ? 200 : 500
    title: details ? 'Upload: ' + details.filename : ''

    function detailsText() {
        if (!details) {
            return ''
        }

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
            visible: details && details.duplicate_filenames !== undefined
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: details && details.duplicate_filenames === undefined
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            border.width: listViewBorder
            border.color: 'whitesmoke'

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 2 * listViewBorder

                visible: details && details.duplicate_filenames !== undefined
                clip: true
                ScrollBar.horizontal: ScrollBar { active: true }
                ScrollBar.vertical: ScrollBar { active: true }
                spacing: 5

                flickableDirection: Flickable.AutoFlickIfNeeded
                boundsBehavior: Flickable.StopAtBounds

                model: details ? details.duplicate_filenames : []
                delegate: Text {
                    text: modelData
                    onWidthChanged: {
                        if (width > listView.contentWidth) {
                            listView.contentWidth = width
                        }
                    }
                }
            }
        }
    }

    standardButtons: Dialog.Ok

}
