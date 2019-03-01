import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    height: layout.height
    width: layout.width

    property alias start : startDateField.dateTime
    property var end : endDateField.dateTime

    function emboldenChoices() {
        unbolden(startLabel, startDateField)
        unbolden(endLabel, endDateField)

        if (start !== null) {
            embolden(startLabel, startDateField)
        }

        if (end !== null) {
            embolden(endLabel, endDateField)
        }
    }

    function embolden(label, dateField) {
        label.font.bold = true
        dateField.textField.font.bold = true
    }

    function unbolden(label, dateField) {
        label.font.bold = false
        dateField.textField.font.bold = false
    }

    //property bool valid: true

//    property alias start: startDateField
//    property alias end: endDateField
//    property bool valid: (start.valid && end.empty) ||
//                         (start.empty && end.valid) ||
//                         (start.valid && end.valid &&
//                          (end.date - start.date >= 0))


    ColumnLayout {
        id: layout
        width: 300

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                id: startLabel
                text: 'Start time:'
            }

            DateTimeField {
                id: startDateField
                Layout.fillHeight: true
                Layout.fillWidth: true
                onDateTimePicked: {
                    root.start = dateTime
                }
            }
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                id: endLabel
                text: 'End time:'
            }

            DateTimeField {
                id: endDateField
                Layout.fillHeight: true
                Layout.fillWidth: true
                onDateTimePicked: {
                    root.end = dateTime
                }
            }
        }
    }

//    DateTextField {
//        id: startDateField
//        deltaMilliseconds: 0 // 00:00:00.000
//        description: qsTr("Start date:")
//        enabled: parent.enabled
//        dateTextColor: (parent.valid || empty) ? 'black' : 'red'
//    }

//    DateTextField {
//        id: endDateField
//        deltaMilliseconds: 24*60*60*1000-1 // 23:59:59.999
//        description: qsTr("End date:")
//        enabled: parent.enabled
//        dateTextColor: (parent.valid || empty) ? 'black' : 'red'
//    }

//    function getAcquisitionTimeAndApply(checked) {
//        if (checked && valid) {
//            let acquisitionTime = {}
//            acquisitionTime.start = start.getTimeAndApply(false)
//            acquisitionTime.end = end.getTimeAndApply(false)
//            return acquisitionTime
//        } else {
//            start.getTimeAndApply(true)
//            end.getTimeAndApply(true)
//            return null
//        }
//    }
}
