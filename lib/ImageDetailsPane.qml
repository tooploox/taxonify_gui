import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    property var currentHoveredItem
    property var currentRightClickedItem

    function makeCopy(obj) {
        return JSON.parse(JSON.stringify(obj))
    }

    function filterKeys(to_filter, allowed_keys) {
        return Object.keys(to_filter)
          .filter(key => allowed_keys.includes(key))
          .reduce((obj, key) => {
            obj[key] = to_filter[key];
            return obj;
          }, {});
    }

    function buildPropertySectionText(obj, full_obj, with_modified, with_date, floats, sectionName) {
        let smallIndent = '&nbsp;&nbsp;&nbsp;'
        let bigIndent = smallIndent + smallIndent
        let text = '<b>' + sectionName + '</b><br>'
        for (const key of Object.keys(obj)) {
            let val = floats ? Number.parseFloat(obj[key]).toFixed(6) : obj[key]
            text += smallIndent + key + ': ' + val

            if (obj[key] !== null && (with_modified || with_date)) {
                text += '<br>' + bigIndent
            }

            if (obj[key] !== null && with_modified) {
                text += '<i>' + full_obj[key + '_modified_by'] + '</i>'
            }
            if (obj[key] !== null && with_date && full_obj[key + '_modification_time']) {
                if (with_modified) {
                    text += '<i>, </i>'
                }

                let time = new Date(full_obj[key + '_modification_time'])
                text += '<i>' + time.toLocaleString(Qt.locale('en_GB'), Locale.ShortFormat) + '</i>'
            }
            text += '<br>'
        }
        return text
    }

    function displayItem(item, label) {
        let meta = item.metadata
        const allowedProperties = imageDetailsPickerDialog.pickedAttributes()

        let text = ''
        if (allowedProperties.taxonomy.length !== 0) {
            const filtered = filterKeys(meta, allowedProperties.taxonomy)
            const ordered = {}
            ItemAttributes.taxonomyAttributes.forEach(key => {
                                                               if (Object.keys(filtered).includes(key)) {
                                                                   ordered[key] = filtered[key]
                                                               }
                                                           })
            text += buildPropertySectionText(ordered, meta, allowedProperties.modified_by,
                                             allowedProperties.modification_time, false, 'Taxonomy')
        }
        if (allowedProperties.morphometry.length !== 0) {
            const filtered = filterKeys(meta, allowedProperties.morphometry)
            text += buildPropertySectionText(filtered, meta, false, false, true, 'Morphometry')
        }
        if (allowedProperties.additionalAttributes.length !== 0) {
            const filtered = filterKeys(meta, allowedProperties.additionalAttributes)
            text += buildPropertySectionText(filtered, meta, allowedProperties.modified_by,
                                              allowedProperties.modification_time, false, 'Additional attributes')
        }
        label.text = text
    }

    function displayHoveredItem(item) {
        if (item !== null) {
            hoverLabelTimer.stop()
            hoverPlaceholderLabel.visible = false
            currentHoveredItem = makeCopy(item)
            displayItem(currentHoveredItem, hoverLabel)
        } else {
            hoverLabelTimer.restart()
        }
    }

    function displayRightClickedItem(item) {
        clickedPlaceholderLabel.visible = false
        currentRightClickedItem = makeCopy(item)
        displayItem(currentRightClickedItem, clickedLabel)

        clickedImagePopup.source = currentRightClickedItem.image
        clickedImagePopup.imageWidth = currentRightClickedItem.metadata.image_width
        clickedImagePopup.imageHeight = currentRightClickedItem.metadata.image_height
    }

    Timer {
        id: hoverLabelTimer
        interval: 500
        running: false
        repeat: false

        onTriggered: {
            hoverPlaceholderLabel.visible = true
        }

    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: 'lightgray'

            Label {
                id: clickedPlaceholderLabel
                anchors.margins: 5
                anchors.fill: parent
                clip: true
                text: "Right-click on image to pin its details here."
                color: 'darkgray'
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: true
            }

            Flickable {
                id: clickedFlickable
                anchors.margins: 5
                anchors.fill: parent
                contentWidth: clickedLabel.width
                contentHeight: clickedLabel.height
                clip: true
                ScrollIndicator.vertical: ScrollIndicator {}
                boundsBehavior: Flickable.StopAtBounds

                Label {
                    id: clickedLabel
                    clip: true
                    visible: !clickedPlaceholderLabel.visible
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 15
                anchors.topMargin: 10
                width: 30
                height: width

                PopupImageLabel {
                    id: clickedImagePopup
                    anchors.fill: parent
                    font.family: fontLoader.name
                    font.pixelSize: 15
                    text: '\uf03e'
                    visible: clickedLabel.visible
                }
            }

        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: 'lightgray'

            Label {
                id: hoverPlaceholderLabel
                anchors.margins: 5
                anchors.fill: parent
                clip: true
                text: "Hover on image to see its details here."
                color: 'darkgray'
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: true
            }

            Flickable {
                id: hoverFlickable
                anchors.margins: 5
                anchors.fill: parent
                contentWidth: hoverLabel.width
                contentHeight: hoverLabel.height
                interactive: false
                clip: true

                Label {
                    id: hoverLabel
                    clip: true
                    visible: !hoverPlaceholderLabel.visible
                }

                contentY: clickedFlickable.contentY
            }
        }

        Button {
            id: filterButton
            text: qsTr('Choose properties')
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            height: 40
            onClicked: imageDetailsPickerDialog.open()
        }
    }

    ImageDetailsPickerDialog {
        id: imageDetailsPickerDialog
        onAccepted: {
            if (currentHoveredItem) {
                displayItem(makeCopy(currentHoveredItem), hoverLabel)
            }
            if (currentRightClickedItem) {
                displayItem(makeCopy(currentRightClickedItem), clickedLabel)
            }
        }
    }

    FontLoader { id: fontLoader; source: 'qrc:/graphics/awesome.ttf'}

}
