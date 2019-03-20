import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal applyClicked(var filter)
    signal userListRequested()

    property alias withApplyButton: applyButton.visible
    property alias withTitle : titleLabel.visible
    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize

    property alias userList: modifiedByFilter.userList
    readonly property var attributes: ItemAttributes.additionalAttributes
    readonly property var filter: buildFilter()

    function updateUserList(data) {
        modifiedByFilter.userList = data
    }

    function emboldenTimeCheckBox(timeDateFilter, timeCheckBox) {

        if (timeCheckBox.checked) {
            timeCheckBox.font.bold = true
            timeDateFilter.emboldenChoices(false)
        } else {
            timeCheckBox.font.bold = false
            timeDateFilter.emboldenChoices(true)
        }
    }

    function emboldenChoices() {
        tagsCheckBox.font.bold = tagsCheckBox.checked

        if (modifiedByCheckBox.checked) {
            modifiedByCheckBox.font.bold = true
            modifiedByFilter.emboldenCurrentChoice()
        } else{
            modifiedByCheckBox.font.bold = false
        }

        if (checkBox1.checked && fileNameField.text.length > 0) {
            fileNameField.placeholderText = fileNameField.text
            checkBox1.font.bold = true
        } else {
            fileNameField.placeholderText = 'File name regex'
            checkBox1.font.bold = false
            checkBox1.checked = false
        }

        emboldenTimeCheckBox(acquisitionTimeDateFilter, acquisitionTimeCheckBox)
        emboldenTimeCheckBox(modificationTimeDateFilter, modificationTimeCheckBox)

        if (taxonomyCkbx.checked) {
            for(let i = 0; i < taxonomyFilter.taxonomyNames.length; i++) {
                var item = taxonomyFilter.container.itemAt(i)
                if(item.checked) {
                    item.apply()
                }
            }
        }
        taxonomyCkbx.font.bold = taxonomyCkbx.checked
        taxonomyFilter.updateBoldness()

        for (let i = 0; i < attributeFilters.count; i++) {
            const attrFilter = attributeFilters.itemAt(i)
            const attrName = attrFilter.attrName
            const attrContainer = attrFilter.container

            attrFilter.apply(attrFilter.checked)
            attrFilter.bold = attrFilter.checked
        }
    }

    function buildFilter() {
        console.debug(Logger.log, "")
        var filter = {}

        if (tagsCheckBox.checked) {
            let tags = tagsField.getTags()
            if (tags.length === 0) {
                tags = ''
            }
            filter.tags = tags
        }

        if (modifiedByCheckBox.checked) {
            filter.modified_by = modifiedByFilter.choice()
        }

        if (checkBox1.checked && fileNameField.text.length > 0) {
            filter.filename = fileNameField.text
        }

        if (acquisitionTimeCheckBox.checked) {
            let acquisitionStartTime = acquisitionTimeDateFilter.start
            if (acquisitionStartTime) {
                filter.acquisition_time_start = acquisitionStartTime.toISOString()
            }

            let acquisitionEndTime = acquisitionTimeDateFilter.end
            if (acquisitionEndTime) {
                filter.acquisition_time_end = acquisitionEndTime.toISOString()
            }
        }

        if (modificationTimeCheckBox.checked) {
            let modificationStartTime = modificationTimeDateFilter.start
            if (modificationStartTime) {
                filter.modification_time_start = modificationStartTime.toISOString()
            }

            let modificationEndTime = modificationTimeDateFilter.end
            if (modificationEndTime) {
                filter.modification_time_end = modificationEndTime.toISOString()
            }
        }

        if (taxonomyCkbx.checked) {
            for(let i = 0; i < taxonomyFilter.taxonomyNames.length; i++) {
                var item = taxonomyFilter.container.itemAt(i)
                if(item.checked) {
                    var key = taxonomyFilter.taxonomyNames[i]
                    var value = item.value
                    if (value === taxonomyFilter.notSpecifiedStr) {
                        value = ''
                    }
                    filter[key] = value
                }
            }
        }

        for (let i = 0; i < attributeFilters.count; i++) {

            const attrFilter = attributeFilters.itemAt(i)
            const attrName = attrFilter.attrName
            const attrContainer = attrFilter.container

            if (attrFilter.checked) {
                var attrChecked = []
                if (attrContainer.itemAt(0).item.checked) {
                    attrChecked.push("true") // attr value is true
                }
                if (attrContainer.itemAt(1).item.checked) {
                    attrChecked.push("false") // attr value is false
                }
                if (attrContainer.itemAt(2).item.checked) {
                    attrChecked.push("") // attr value is not specified
                }
                if (attrChecked.length > 0) {
                    filter[attrName] = attrChecked
                }
            }
        }
        return filter
    }

    ColumnLayout {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Label {
            id: titleLabel
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Filtering")
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            clip: true
            contentWidth: width

            ColumnLayout {

                width: parent.width

                ButtonGroup {
                    id: filterButtons
                    exclusive: false
                }

                ColumnLayout {
                    Layout.rightMargin: 20
                    Layout.fillWidth: true

                    CheckBox {
                        id: tagsCheckBox
                        checked: false
                        text: qsTr("Tags")
                        ButtonGroup.group: filterButtons
                    }
                    TagsField {
                        id: tagsField
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        height: 110
                        visible: tagsCheckBox.checked
                    }
                }

                ColumnLayout {
                    Layout.rightMargin: 20
                    Layout.fillWidth: true

                    CheckBox {
                        id: modifiedByCheckBox
                        checked: false
                        text: qsTr("Modified by")
                        ButtonGroup.group: filterButtons
                    }

                    ModifiedByFilter {
                        id: modifiedByFilter
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        visible: modifiedByCheckBox.checked
                    }
                }

                Column {

                    CheckBox {
                        id: checkBox1
                        checked: false
                        text: qsTr("File name")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 20

                        TextField {
                            id: fileNameField
                            enabled: checkBox1.checked
                            placeholderText: 'File name regex'
                            visible: checkBox1.checked

                        }
                    }
                }

                Column {

                    CheckBox {
                        id: acquisitionTimeCheckBox
                        checked: false
                        text: qsTr("Acquisition Time")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 20

                        DateFilter {
                            id: acquisitionTimeDateFilter
                            enabled: acquisitionTimeCheckBox.checked
                            visible: acquisitionTimeCheckBox.checked
                        }
                    }
                }

                Column {

                    CheckBox {
                        id: modificationTimeCheckBox
                        checked: false
                        text: qsTr("Modification Time")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 20

                        DateFilter {
                            id: modificationTimeDateFilter
                            enabled: modificationTimeCheckBox.checked
                            visible: modificationTimeCheckBox.checked
                        }
                    }
                }

                Column {
                    Layout.fillWidth: true
                    Layout.rightMargin: 20

                    CheckBox {
                        id: taxonomyCkbx
                        checked: false
                        text: qsTr("Taxonomy")
                        ButtonGroup.group: filterButtons
                    }

                    TaxonomyFilter {
                        id: taxonomyFilter
                        enabled: taxonomyCkbx.checked
                        visible: taxonomyCkbx.checked
                        width: parent.width
                    }
                }

                Repeater {
                    id: attributeFilters
                    model: attributes

                    Column {

                        property string attrName: modelData
                        property alias checked: attrCbx.checked
                        property alias bold: attrCbx.font.bold
                        property alias container: attrFilter.container
                        property alias apply: attrFilter.apply

                        CheckBox {
                            id: attrCbx
                            checked: false
                            text: preformatAttrName(attrName)
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 20

                            AttributeFilter {
                                id: attrFilter
                                attributeName: attrName
                                enabled: checked
                                visible: checked
                            }
                        }

                        function preformatAttrName(name) {
                            return (name.charAt(0).toUpperCase() + name.slice(1)).replace(/[_]/g, " ")
                        }
                    }
                }
            }
        }

        Button {
            id: applyButton
            text: qsTr('Apply filters')

            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            height: 40

            onClicked: {
                console.debug(Logger.log, "applyButton")
                let filter = buildFilter()
                emboldenChoices()
                applyClicked(filter)
            }
        }
    }

    Component.onCompleted: {
       console.debug(Logger.log, "FilteringPane")
       userListRequested()
    }
}
