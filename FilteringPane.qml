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

            GroupBox {

                Layout.fillWidth: true

                label: CheckBox {
                    id: checkBox1
                    checked: true
                    text: qsTr("File name")
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
                    checked: true
                    text: qsTr("Date")
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
                    checked: true
                    text: qsTr("Taxonomy")
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
                    checked: true
                    text: qsTr("Liveness")
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
                    if (taxonomyCkbx.checked) {
                        if (taxonomyFilter.container.itemAt(0).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.empire = taxonomyFilter.container.itemAt(0).value
                        }
                        if (taxonomyFilter.container.itemAt(1).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.kingdom = taxonomyFilter.container.itemAt(1).value
                        }
                        if (taxonomyFilter.container.itemAt(2).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.phylum = taxonomyFilter.container.itemAt(2).value
                        }
                        if (taxonomyFilter.container.itemAt(3).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.class = taxonomyFilter.container.itemAt(3).value
                        }
                        if (taxonomyFilter.container.itemAt(4).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.order = taxonomyFilter.container.itemAt(4).value
                        }
                        if (taxonomyFilter.container.itemAt(5).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.family = taxonomyFilter.container.itemAt(5).value
                        }
                        if (taxonomyFilter.container.itemAt(6).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.genus = taxonomyFilter.container.itemAt(6).value
                        }
                        if (taxonomyFilter.container.itemAt(7).value !== taxonomyFilter.notSpecifiedStr) {
                            filter.species = taxonomyFilter.container.itemAt(7).value
                        }
                    }
                    if (livenessCkbx.checked) {
                        var livenessChecked = []
                        if (livenessFilter.container.itemAt(0).item.checked) {
                            livenessChecked.push("false") //dead false
                        }
                        if (livenessFilter.container.itemAt(1).item.checked) {
                            livenessChecked.push("true") //dead true
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
