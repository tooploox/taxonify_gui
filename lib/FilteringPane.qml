import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal applyClicked(var filter)
    property alias withApplyButton: applyButton.visible
    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize

    property var userList: []
    readonly property var attributes: FilteringAttributes.filteringAttributes
    readonly property var filter: buildFilter()

    function emboldenChoices() {
        if (modifiedByCheckBox.checked) {
            modifiedByCheckBox.font.bold = true
            modifiedByFilter.emboldenCurrentChoice()
        }

        if (checkBox1.checked && fileNameField.text.length > 0) {
            fileNameField.placeholderText = fileNameField.text
            checkBox1.font.bold = true
        } else {
            fileNameField.placeholderText = 'File name regex'
            checkBox1.font.bold = false
            checkBox1.checked = false
        }

        const acquisitionTime = dateFilter.getAcquisitionTimeAndApply(dateCkbx.checked)
        if (acquisitionTime) {
            dateCkbx.font.bold = true
        } else {
            dateCkbx.font.bold = false
            dateCkbx.checked = false
        }

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

        let startTime = dateFilter.start.isostring
        if (startTime) {
            filter.acquisition_time_start = startTime
        }

        let endTime = dateFilter.end.isostring
        if (endTime) {
            filter.acquisition_time_end = endTime
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
                        width: parent.width
                        id: modifiedByFilter
                        visible: modifiedByCheckBox.checked
                        userList: root.userList
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
                        id: dateCkbx
                        checked: false
                        text: qsTr("Date")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 20

                        DateFilter {
                            id: dateFilter
                            enabled: dateCkbx.checked
                            visible: dateCkbx.checked
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
