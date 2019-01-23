import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
//import QtQuick.Controls.Styles 1.4
//import QtQml 2.2

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
                    id: dateInputTextField
                    enabled: checkBox0.checked

                    anchors.fill: parent

                    RowLayout {

                        Text {
                            text: qsTr("Start date:")
                            color: dateInputTextField.enabled ? "black" : "gray"
                            Layout.preferredWidth: 80
                        }
                        TextInput {
                            id: txIpStartDate

                            property bool eddited: false
                            enabled: dateInputTextField.enabled
                            color: getDateTextColor(text, txIpEndDate.text,
                                                    dateInputTextField.enabled)
                            inputMask: "9999-99-99;_"

                            ToolTip.visible: eddited
                            ToolTip.delay: 200
                            ToolTip.text: qsTr("yyyy-mm-dd")

                            onTextEdited: {
                                txIpStartDate.eddited = true
                            }
                        }
                    }

                    RowLayout {
                        Text {
                            text: qsTr("End date:")
                            color: dateInputTextField.enabled ? "black" : "gray"
                            Layout.preferredWidth: 80
                        }
                        TextInput {
                            id: txIpEndDate

                            property bool eddited: false
                            enabled: dateInputTextField.enabled
                            color: getDateTextColor(txIpStartDate.text, text,
                                                    dateInputTextField.enabled)
                            inputMask: "9999-99-99;_"

                            ToolTip.visible: eddited
                            ToolTip.delay: 200
                            ToolTip.text: qsTr("yyyy-mm-dd")

                            onTextEdited: {
                                txIpEndDate.eddited = true
                            }

                        }
                    }
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

            LivenessFilter {
                Layout.fillWidth: true
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


    function getDateTextColor(startDateText, endDateText, isInputEnabled) {
        if (isInputEnabled) {
            if (validateDateTextInputs(startDateText, endDateText)) {
                return "black"
            } else {
                return "red"
            }
        } else {
            return "gray"
        }
    }

    function validateDateTextInputs(startDateText, endDateText) {
        if ((startDateText === "--" || endDateText === "--")){
            if (isDateValid(endDateText) || isDateValid(startDateText)) {
                return true
            } else {
                return false
            }
        } else {
            if  (isDateValid(endDateText) && isDateValid(startDateText)) {
                return endDateAfterThenStartDate(startDateText, endDateText)
            } else {
                return false
            }
        }
    }

    function isDateValid(text) {
        var d = new Date(text)
        var validDay = (d.getDate() === Number(text.split("-")[2]))
        var validMonth = (d.getMonth() + 1 === Number(text.split("-")[1]))
        var validYear = (d.getFullYear() === Number(text.split("-")[0]))
        return (validDay && validMonth && validYear) ? true : false
    }

    function endDateAfterThenStartDate(startDateText, endDateText) {
        var sDate = new Date(startDateText)
        var eDate = new Date(endDateText)
        return (eDate - sDate >= 0) ? true : false
    }
}
