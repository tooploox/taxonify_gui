import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/network"

Rectangle {
    border.color: 'lightgray'

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
                        filter.filename = fileNameField.text
                    }
                    /*
                    if (checkBox0.checked) {
                        filter.
                    }*/

                    filterItemsReq.call(filter)
                }
            }
        }
    }   
}
