import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    function criteria() {
        return filteringPane.buildFilter()
    }

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillHeight: true

            FilteringPane {
                id: filteringPane
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                withApplyButton: false
            }

        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 5

            CheckBox {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5

                checked: false
                enabled: false
                text: "Include images"
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5

                CheckBox {
                    id: limitCheckBox

                    Layout.alignment: Qt.AlignLeft
                    checked: true
                    enabled: true
                    text: "Limit results to first"
                }

                TextField {
                    Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
                    text: "1000"
                    enabled: limitCheckBox.checked
                    selectByMouse: true
                    validator: IntValidator { bottom: 1 }
                    //inputMethodHints: Qt.ImhDigitsOnly
                }


            }

            TextArea {
                id: filterTextArea
                readOnly: true

                Layout.fillHeight: true
                Layout.fillWidth: true

                text: "hello"
            }

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5


                text: "By clicking \"OK\" you will download data that matches provided criteria."
            }
        }

    }






}
