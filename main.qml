import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640 * 2
    height: 480 * 1.5
    title: qsTr("Aquascope Data Browser")

    DataModel {
        id: itemsModel
    }

    RowLayout {

        anchors.fill: parent

        Rectangle {
            id: filterBox
            //color: 'red'

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

                        ColumnLayout {
                            id: cl
                            anchors.fill: parent
                            enabled: checkBox2.checked

                            property var names: [
                                ["Prokaryota", "Eukaryota"],
                                ["Bacteria", "Chromista"],
                                ["Chrysophyceae", "Bicosea"],
                                ["Nostocales", "Oscillatoriales"],
                                ["Coelosphaeriaceae", "Gomphosphaeriaceae", "Microcystaceae"],
                                ["Aphanothece", "Chroococcus"]
                            ]

                            Repeater {

                                model: cl.names.length

                                ComboBox {
                                    Layout.fillWidth: true
                                    model: cl.names[index]
                                }
                            }
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

        ColumnLayout {

            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                border.color: 'lightgray'
                Layout.fillWidth: true
                Layout.preferredHeight: 50



                Row {
                    anchors.fill: parent

                    anchors.leftMargin: 10

                    ComboBox {
                        width: 200
                        model: ["Sort by date", "Sort by size", "Sort by something"]
                    }

                    RadioButton {
                        checked: true
                        text: qsTr("Ascending")
                    }

                    RadioButton {
                        text: qsTr("Descending")
                    }
                }
            }

            GridView {
                id: grid
                //anchors.fill: parent

                clip: true

                Layout.fillWidth: true
                Layout.fillHeight: true

                cellWidth: 100 + tileSizeSlider.value * 150
                cellHeight: 100 + tileSizeSlider.value * 150

                model: itemsModel

                delegate: Item {

                    width: grid.cellWidth
                    height: grid.cellWidth

                    Rectangle {

                        id: rect

                        anchors.centerIn: parent
                        width: parent.width - 10
                        height: parent.height - 10

                        state: model.selected ? 'selected' : 'basic'

                        states: [
                            State {
                                name: "basic"
                                PropertyChanges {
                                    target: rect

                                    border.color: 'darkblue'
                                    border.width: 2
                                    color: 'lightgray'
                                }
                            },
                            State {
                                name: "selected"
                                PropertyChanges {
                                    target: rect

                                    border.color: 'red'
                                    border.width: 4
                                    color: 'lightblue'
                                }
                            }
                        ]

                        Image {
                            width: parent.width - 10
                            height: parent.height - 10

                            fillMode: Image.PreserveAspectFit

                            anchors.centerIn: parent

                            source: image
                            clip: true
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: model.selected = !model.selected
                        }
                    }
                }
            }

            Rectangle {
                border.color: 'lightgray'
                Layout.fillWidth: true
                Layout.preferredHeight: 50

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10

                    Label {
                        text: "Tile size:"
                    }

                    Slider {
                        id: tileSizeSlider
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }

        Rectangle {
            id: selectionBox
            //color: 'red'

            border.color: 'lightgray'

            Layout.preferredWidth: 300
            Layout.fillHeight: true

            ColumnLayout {

                width: parent.width

                Label {
                    Layout.fillWidth: true
                    text: "Annotation"
                    font.pixelSize: 25
                    horizontalAlignment: Text.AlignHCenter
                }

                GroupBox {

                    Layout.fillWidth: true

                    label: CheckBox {
                        id: checkBox6
                        checked: true
                        text: qsTr("Taxonometry")
                    }

                    ColumnLayout {
                        id: cl2
                        anchors.fill: parent
                        enabled: checkBox6.checked

                        property var names: [
                            ["Prokaryota", "Eukaryota"],
                            ["Bacteria", "Chromista"],
                            ["Chrysophyceae", "Bicosea"],
                            ["Nostocales", "Oscillatoriales"],
                            ["Coelosphaeriaceae", "Gomphosphaeriaceae", "Microcystaceae"],
                            ["Aphanothece", "Chroococcus"]
                        ]

                        Repeater {

                            model: cl2.names.length

                            ComboBox {
                                Layout.fillWidth: true
                                model: cl2.names[index]
                            }
                        }
                    }
                }

                GroupBox {

                    Layout.fillWidth: true

                    label: CheckBox {
                        id: checkBox4
                        checked: true
                        text: qsTr("Liveness")
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        enabled: checkBox4.checked
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
                    text: 'Apply to selected images'

                    Layout.alignment: Qt.AlignCenter
                }
            }
        }
    }
}

