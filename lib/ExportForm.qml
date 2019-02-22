import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    readonly property var exportCriteria: criteria()

    function criteria() {
        let crit = filteringPane.filter
        if (limitCheckBox.checked) {
            crit.limit = limitTextField.text
        }
        return crit
    }

    function buildCriteriaText() {
        filterTextArea.text = JSON.stringify(criteria(), null, 2)
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
                onFilterChanged: buildCriteriaText()

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
                    onCheckedChanged: buildCriteriaText()
                }

                TextField {
                    id: limitTextField
                    Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
                    text: "1000"
                    enabled: limitCheckBox.checked
                    selectByMouse: true
                    validator: IntValidator { bottom: 1 }

                    onTextChanged: {
                        if (enabled) {
                            buildCriteriaText()
                        }
                    }
                }
            }

            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 5
                clip: true

                TextArea {
                    id: filterTextArea
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    readOnly: true

                    FontLoader { id: fixedFont; name: "Courier" }
                    font { family: fixedFont.name; pointSize: 10 }
                    background: Rectangle {
                        color: 'whitesmoke'
                    }
                }
            }

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5
                text: "By clicking \"OK\" you will download data that matches provided criteria."
            }
        }

    }
}
