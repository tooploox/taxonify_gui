import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal filterApplyClicked(var filter)

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

                        anchors.fill: parent

                        TextField {
                            id: fileNameField
                            enabled: checkBox1.checked
                            placeholderText: 'File name regex'
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

                    DateFilter {
                        id: dateFilter
                        anchors.fill: parent
                        enabled: dateCkbx.checked
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

                    TaxonomyFilter {
                        id: taxonomyFilter
                        enabled: taxonomyCkbx.checked
                    }
                }

                GroupBox {
                    Layout.fillWidth: true

                    label: CheckBox {
                        id: livenessCkbx
                        checked: false
                        text: qsTr("Liveness")
                        ButtonGroup.group: filterButtons
                    }

                    LivenessFilter {
                        id: livenessFilter
                        enabled: livenessCkbx.checked
                        annotationMode: false
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

                livenessFilter.apply(livenessCkbx.checked)
                livenessCkbx.font.bold = livenessCkbx.checked
                if (livenessCkbx.checked) {
                    var livenessChecked = []
                    if (livenessFilter.container.itemAt(0).item.checked) {
                        livenessChecked.push("false") // dead false
                    }
                    if (livenessFilter.container.itemAt(1).item.checked) {
                        livenessChecked.push("true") // dead true
                    }
                    if (livenessFilter.container.itemAt(2).item.checked) {
                        livenessChecked.push("") // not specified
                    }
                    if (livenessChecked.length > 0) {
                        filter.dead = livenessChecked
                    }
                }

                filterApplyClicked(filter)
            }
        }
    }
}
