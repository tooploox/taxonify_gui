import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal applyClicked(var filter)
    signal userListRequested()

    property alias withApplyButton: applyButton.visible
    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize

    property alias userList: modifiedByFilter.userList
    readonly property var attributes: FilteringAttributes.filteringAttributes
    readonly property var filter: buildFilter()

    onVisibleChanged: {
        if (visible) {
            userListRequested()
        }
    }

    function emboldenTimeCheckBox(timeDateFilter, timeCheckBox) {
        const time = timeDateFilter.getAcquisitionTimeAndApply(timeCheckBox.checked)
        if (time) {
            time.font.bold = true
        } else {
            timeCheckBox.font.bold = false
            timeCheckBox.checked = false
        }
    }

    function emboldenChoices() {
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
        taxonomyFilter.update()

        for (let i = 0; i < attributeFilters.count; i++) {
            const attrFilter = attributeFilters.itemAt(i)
            const attrName = attrFilter.attrName
            const attrContainer = attrFilter.container

            attrFilter.apply(attrFilter.checked)
            attrFilter.bold = attrFilter.checked
        }
    }

    function buildFilter() {
        var filter = {}

        if (modifiedByCheckBox.checked) {
            filter.modified_by = modifiedByFilter.choice()
        }

        if (checkBox1.checked && fileNameField.text.length > 0) {
            filter.filename = fileNameField.text
        }

        if (acquisitionTimeCheckBox.checked) {
            let acquisitionStartTime = acquisitionTimeDateFilter.start.isostring
            if (acquisitionStartTime) {
                filter.acquisition_time_start = acquisitionStartTime
            }

            let acquisitionEndTime = acquisitionTimeDateFilter.end.isostring
            if (acquisitionEndTime) {
                filter.acquisition_time_end = acquisitionEndTime
            }
        }

        if (modificationTimeCheckBox.checked) {
            let modificationStartTime = modificationTimeDateFilter.start.isostring
            if (modificationStartTime) {
                filter.modification_time_start = modificationStartTime
            }

            let modificationEndTime = modificationTimeDateFilter.end.isostring
            if (modificationEndTime) {
                filter.modification_time_end = modificationEndTime
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
                //width: 200//parent.viewport.width

                ButtonGroup {
                    id: filterButtons
                    exclusive: false
                }

                Column {
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
                        width: parent.width
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
                let filter = buildFilter()
                emboldenChoices()
                applyClicked(filter)
            }
        }
    }
}
