import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    signal userListRequested()

    readonly property var exportCriteria: criteria()

    function updateUserList(data){
        filteringPane.updateUserList(data)
    }

    function criteria() {
        let crit = filteringPane.filter
        if (limitCheckBox.checked) {
            crit.limit = limitTextField.text
        }
        return crit
    }

    function buildCriteriaText() {
        console.debug(Logger.log, "")
        filterTextArea.text = JSON.stringify(criteria(), null, 2)
    }

    function acceptLimitInput() {
        console.debug(Logger.log, "")
        limitTextWarning.visible = false
        buildCriteriaText()
    }

    function denyLimitInput() {
        console.debug(Logger.log, "")
        limitTextWarning.visible = true

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
                title: "Export filter"
                titleSize: 20

                onUserListRequested: {
                    console.debug(Logger.log, "filteringPane")
                    root.userListRequested()
                }
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
                    onCheckedChanged: {
                        console.debug(Logger.log, "limitCheckBox")
                        buildCriteriaText()
                    }
                }

                TextField {
                    id: limitTextField
                    Layout.alignment: Qt.AlignRight | Qt.AlignHCenter
                    text: "1000"
                    enabled: limitCheckBox.checked
                    selectByMouse: true
                    validator: IntValidator { bottom: 1 }

                    onTextChanged: {
                        console.debug(Logger.log, "limitTextField")
                        if (!acceptableInput) {
                            console.debug(Logger.log, "not acceptable Input")
                            denyLimitInput()
                        } else if (enabled && acceptableInput) {
                            console.debug(Logger.log, "enabled and acceptable Input")
                            acceptLimitInput()
                        }
                    }
                }
            }

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5
                id: limitTextWarning
                text: "Limit must be a number greater than 0."
                color: 'red'
                visible: false
            }

            Label {
                Layout.topMargin: 20
                Layout.leftMargin: 5
                text: 'Export filter summary'
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
