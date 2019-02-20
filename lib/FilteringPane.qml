import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal applyClicked(var filter)

    readonly property var attributes: FilteringAttributes.filteringAttributes

    ColumnLayout {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Filtering")
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: parent.height - 100
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

                    Layout.fillWidth: true

                    CheckBox {
                        id: checkBox1
                        checked: false
                        text: qsTr("File name")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        TextField {
                            id: fileNameField
                            enabled: checkBox1.checked
                            placeholderText: 'File name regex'
                            visible: checkBox1.checked

                        }

                    }
                }

                Column {

                    Layout.fillWidth: true

                    CheckBox {
                        id: dateCkbx
                        checked: false
                        text: qsTr("Date")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 10

                        DateFilter {
                            id: dateFilter
                            enabled: dateCkbx.checked
                            visible: dateCkbx.checked
                        }
                    }
                }

                GroupBox {

                    Layout.fillWidth: true

                    label: CheckBox {
                        id: taxonomyCkbx
                        checked: false
                        text: qsTr("Taxonomy")
                        ButtonGroup.group: filterButtons
                    }


                    Column {
                        anchors.fill: parent

                        TaxonomyFilter {
                            id: taxonomyFilter
                            enabled: taxonomyCkbx.checked
                            visible: taxonomyCkbx.checked
                            width: parent.width
                        }
                    }

                }

                Repeater {
                    id: attributefltrs
                    model: attributes

                    Column {

                        property string attrName: modelData
                        property alias checked: attrCbx.checked
                        property alias bold: attrCbx.font.bold
                        property alias container: attrFltr.container
                        property alias apply: attrFltr.apply

                        CheckBox {
                            id: attrCbx
                            checked: false
                            text: preformatAttrName(attrName)
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 10

                            AttributeFilter {
                                id: attrFltr
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

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Button {
            text: qsTr('Apply filters')

            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            height: 40

            onClicked: {
                var filter = {}

                if (checkBox1.checked && fileNameField.text.length > 0) {
                    filter.filename = fileNameField.text
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
                    if (acquisitionTime.start)
                        filter.acquisition_time_start = acquisitionTime.start
                    if (acquisitionTime.end)
                        filter.acquisition_time_end = acquisitionTime.end
                } else {
                    dateCkbx.font.bold = false
                    dateCkbx.checked = false
                }

                if (taxonomyCkbx.checked) {
                    for(let i = 0; i < taxonomyFilter.taxonomyNames.length; i++) {
                        var item = taxonomyFilter.container.itemAt(i)
                        if(item.checked) {
                            item.apply()
                            var key = taxonomyFilter.taxonomyNames[i]
                            var value = item.value
                            if (value === taxonomyFilter.notSpecifiedStr) {
                                value = ''
                            }
                            filter[key] = value
                        }
                    }
                }
                taxonomyCkbx.font.bold = taxonomyCkbx.checked
                taxonomyFilter.update()

                for (let i = 0; i < attributefltrs.count; i++) {

                    const attrFltr = attributefltrs.itemAt(i)
                    const attrName = attrFltr.attrName
                    const attrContainer = attrFltr.container

                    attrFltr.apply(attrFltr.checked)
                    attrFltr.bold = attrFltr.checked

                    if (attrFltr.checked) {
                        var attrChecked = []
                        if (attrContainer.itemAt(0).item.checked) {
                            attrChecked.push("false") // attr value is false
                        }
                        if (attrContainer.itemAt(1).item.checked) {
                            attrChecked.push("true") // attr value is true
                        }
                        if (attrContainer.itemAt(2).item.checked) {
                            attrChecked.push("") // attr value is not specified
                        }
                        if (attrChecked.length > 0) {
                            filter[attrName] = attrChecked
                        }
                    }
                }

                applyClicked(filter)
            }
        }
    }
}
