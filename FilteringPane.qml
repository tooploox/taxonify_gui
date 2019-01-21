import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {

    border.color: 'lightgray'

    Layout.preferredWidth: 300
    Layout.fillHeight: true

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
                        enabled: checkBox1.checked
                        placeholderText: 'File name regex'
                    }

                }
            }

            GroupBox {

                Layout.fillWidth: true

                label: CheckBox {
                    id: checkBox0
                    checked: true
                    text: qsTr("Date")
                }

                Column {

                    anchors.fill: parent

                    TextField {
                        enabled: checkBox0.checked
                        placeholderText: 'start date'
                    }


                    TextField {
                        enabled: checkBox0.checked
                        placeholderText: 'end date'
                    }
                }
            }

            GroupBox {

                Layout.fillWidth: true

                label: CheckBox {
                    id: checkBox2
                    checked: true
                    text: qsTr("Taxonometry")
                }

                TaxonomyFilter {
                    enabled: checkBox2.checked
                }
            }

            GroupBox {

                Layout.fillWidth: true

                label: CheckBox {
                    id: checkBox
                    checked: true
                    text: qsTr("Liveness")
                }

                ColumnLayout {
                    anchors.fill: parent
                    enabled: checkBox.checked
                    CheckBox { text: qsTr("Alive") }
                    CheckBox { text: qsTr("Dead") }
                    CheckBox { text: qsTr("Not specified") }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }


            Button {
                text: 'Apply filters'

                Layout.alignment: Qt.AlignCenter
            }
        }
    }

}
