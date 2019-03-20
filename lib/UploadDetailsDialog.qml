import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Dialog {
    id: root

    modal: true
    parent: ApplicationWindow.overlay
    property var details: null
    property var lastTags: []
    readonly property bool displayDuplicates: details && details.duplicate_filenames !== undefined
                                              && details.duplicate_image_count !== 0
    readonly property bool displayBrokens: details && details.broken_records !== undefined
                                              && details.broken_record_count !== 0

    height: (displayDuplicates || displayBrokens) ? 700 : 400
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

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !displayDuplicates && !displayBrokens
        }

        UploadFilenamesView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 5

            title: 'Duplicate filenames:'
            visible: displayDuplicates
            model: displayDuplicates ? details.duplicate_filenames : []
        }

        UploadFilenamesView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 5

            title: 'Broken records:'
            visible: displayBrokens
            model: displayBrokens ? details.broken_records : []
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
