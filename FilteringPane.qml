import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal appliedClicked(var filter)

    ScrollView {

        anchors.fill: parent
        contentWidth: width

        ColumnLayout {

            width: parent.width
            //width: 200//parent.viewport.width

            Label {
                Layout.fillWidth: true
                text: "Filtering"
                font.pixelSize: 25
                horizontalAlignment: Text.AlignHCenter
            }

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
                    isAnnotationMode: false
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }


            Button {
                text: 'Apply filters'

                Layout.alignment: Qt.AlignCenter

                onClicked: {
                    var filter = {}
                    if (checkBox1.checked) {
                        if (fileNameField.text.length>0) {
                            filter.filename = fileNameField.text
                        }
                    }
                    if (dateCkbx.checked && dateFilter.valid) {
                        if (!dateFilter.start.empty) {
                            console.log(dateFilter.start.isostring)
                            filter.acquisition_time_start = dateFilter.start.isostring
                        }
                        if (!dateFilter.end.empty) {
                            console.log(dateFilter.end.isostring)
                            filter.acquisition_time_end = dateFilter.end.isostring
                        }
                    }
                    for(let i = 0; i < taxonomyFilter.taxonomyNames.length; i++) {
                        if(taxonomyFilter.container.itemAt(i).checked) {
                            var key = taxonomyFilter.taxonomyNames[i]
                            var value = taxonomyFilter.container.itemAt(i).value
                            if (value === taxonomyFilter.notSpecifiedStr) {
                                value = ''
                            }
                            filter[key] = value
                        }
                    }
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

                    appliedClicked(filter)
                }
            }
        }
    }
}
