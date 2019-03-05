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
                let time = new Date(full_obj[key + '_modification_time'])
                text += '<i>, ' + time.toLocaleString(Qt.locale('en_GB'), Locale.ShortFormat) + '</i>'
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
            FilteringAttributes.taxonomyAttributes.forEach(key => {
                                                               if (Object.keys(filtered).includes(key)) {
                                                                   ordered[key] = filtered[key]
                                                               }
                                                           })
            text += buildPropertySectionText(ordered, meta, true, true, false, 'Taxonomy')
        }
        if (allowedProperties.morphometry.length !== 0) {
            const filtered = filterKeys(meta, allowedProperties.morphometry)
            text += buildPropertySectionText(filtered, meta, false, false, true, 'Morphometry')
        }
        if (allowedProperties.additionalAttributes.length !== 0) {
            const filtered = filterKeys(meta, allowedProperties.additionalAttributes)
            text += buildPropertySectionText(filtered, meta, true, true, false, 'Additional attributes')
        }
        label.text = text
    }

    function displayHoveredItem(item) {
        currentHoveredItem = makeCopy(item)
        displayItem(currentHoveredItem, hoverLabel)
    }

    function displayRightClickedItem(item) {
        currentRightClickedItem = makeCopy(item)
        displayItem(currentRightClickedItem, clickedLabel)
    }

    FontLoader {
        id: fontLoader
        source: 'qrc:/graphics/awesome.ttf'
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: 'lightgray'

            Label {
                id: clickedLabel
                anchors.margins: 5
                anchors.fill: parent
                clip: true
            }
        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: 'lightgray'


            Label {
                id: hoverLabel
                anchors.margins: 5
                anchors.fill: parent
                clip: true
            }
        }
        Row {
            Layout.fillWidth: true
            Layout.preferredHeight: filterButton.height

            Button {
                id: filterButton
                text: '\uf0b0'
                font.family: fontLoader.name
                font.pixelSize: 16
                width: 30
                height: width
                onClicked: imageDetailsPickerDialog.open()
            }
        }
    }

    ImageDetailsPickerDialog {
        id: imageDetailsPickerDialog
        onAccepted: {
            displayItem(makeCopy(currentHoveredItem), hoverLabel)
            displayItem(makeCopy(currentRightClickedItem), clickedLabel)
        }
    }

}
