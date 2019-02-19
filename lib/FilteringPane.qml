import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    signal appliedClicked(var filter)
    property alias withApplyButton: applyButton.visible

    function buildFilter() {
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
            visible : withApplyButton ? true : false
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: parent.height - titleLabel.height - applyButton.height - 20
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
            Layout.fillHeight: withApplyButton ? true : false
            Layout.fillWidth: withApplyButton ? true : false
        }

        Button {
            id: applyButton
            text: qsTr('Apply filters')
            visible: true

            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            height: visible ? 40 : 0
            onClicked: {
                let filter = buildFilter()
                appliedClicked(filter)
            }
        }
    }
}
