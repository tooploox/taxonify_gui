import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    height: layout.height
    width: layout.width

    property alias start : startDate.dateTime
    property alias end : endDate.dateTime

    function emboldenChoices() {
        startDate.setBold(false)
        endDate.setBold(false)

        if (start !== null) {
            startDate.setBold(true)
        }

        if (end !== null) {
            endDate.setBold(true)
        }
    }

    ColumnLayout {
        id: layout
        width: 300

        DateTimeFieldAndLabel {
            id: startDate
            Layout.fillHeight: true
            Layout.fillWidth: true

            text: 'Start time:'

            onDateTimePicked: {
                root.start = dateTime
            }
        }

        DateTimeFieldAndLabel {
            id: endDate
            Layout.fillHeight: true
            Layout.fillWidth: true

            text: 'End time:'

            onDateTimePicked: {
                root.end = dateTime
            }
        }
    }
}
