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
}
