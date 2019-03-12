import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Dialog {
    id: root

    modal: true
    parent: ApplicationWindow.overlay
    readonly property int listViewBorder: 1
    property var details: null
    property var lastTags: []

    height: details && details.duplicate_filenames === undefined ? 400 : 600
    title: details ? 'Upload: ' + details.filename : ''

    signal tagsUpdateRequested(string upload_id, var tags)

    onDetailsChanged: {
        if (!details) {
            return
        }
        lastTags = details.tags
        tagsField.tags = details.tags
    }

    function detailsText() {
        if (!details) {
            return ''
        }

        let text = ''
        text += 'Name: ' + details.filename + '<br>'
        text += 'Status: ' + details.state + '<br>'

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

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: 'Tags:'
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: 'Edit'
            }

            Switch {
                id: editTagsSwitch
                checked: false
            }
        }

        TagsField {
            id: tagsField
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            readOnly: !editTagsSwitch.checked
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
            border.color: 'lightgray'
            color: 'whitesmoke'
            visible: details && details.duplicate_filenames !== undefined

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 2 * listViewBorder

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

    onAccepted: {
        editTagsSwitch.checked = false
        let tags = tagsField.getTags()
        if (JSON.stringify(tags) !== JSON.stringify(lastTags)) {
            tagsUpdateRequested(details._id, tags)
        }
    }

}
