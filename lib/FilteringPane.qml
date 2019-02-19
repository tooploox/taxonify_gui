import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal applyClicked(var filter)

    property var attributes: ['with_eggs', 'dividing', 'dead', 'with_epibiont', 'with_parasite', 'broken',
        'colony', 'cluster', 'eating', 'multiple_species', 'partially_cropped', 'male',
        'female', 'juvenile', 'adult', 'ephippium', 'resting_egg', 'heterocyst', 'akinete',
        'with_spines', 'beatles', 'stones', 'zeppelin', 'floyd', 'acdc', 'hendrix',
        'alan_parsons', 'allman', 'dire_straits', 'eagles', 'guns', 'purple', 'van_halen',
        'skynyrd', 'zz_top', 'iron', 'police', 'moore', 'inxs', 'chilli_peppers']

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

                GroupBox {

                    Layout.fillWidth: true

                    label: CheckBox {
                        id: checkBox1
                        checked: false
                        text: qsTr("File name")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
                        TextField {
                            id: fileNameField
                            enabled: checkBox1.checked
                            placeholderText: 'File name regex'
                            visible: checkBox1.checked

                        }

                    }
                }

                GroupBox {

                    Layout.fillWidth: true

                    label: CheckBox {
                        id: dateCkbx
                        checked: false
                        text: qsTr("Date")
                        ButtonGroup.group: filterButtons
                    }

                    Column {
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

                    GroupBox {

                        property string attrName: modelData
                        property alias checked: attrCbx.checked
                        property alias bold: attrCbx.font.bold
                        property alias container: attrFltr.container
                        property alias apply: attrFltr.apply

                        Layout.fillWidth: true

                        label: CheckBox {
                            id: attrCbx
                            checked: false
                            text: attrName
                        }

                        Column {
                            AttributeFilter {
                                id: attrFltr
                                attributeName: attrName
                                enabled: checked
                                visible: checked
                            }
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
