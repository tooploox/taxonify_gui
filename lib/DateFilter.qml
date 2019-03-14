import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    height: layout.height
    width: layout.width

    property alias start : startDate.dateTime
    property alias end : endDate.dateTime

    function emboldenChoices(forceInactive) {
        startDate.setBold(false)
        endDate.setBold(false)

        if (!forceInactive) {
            if (start !== null) {
                startDate.setBold(true)
            }

            if (end !== null) {
                endDate.setBold(true)
            }
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
                console.debug(Logger.log, "startDate")
                root.start = dateTime
            }
        }

        DateTimeFieldAndLabel {
            id: endDate
            Layout.fillHeight: true
            Layout.fillWidth: true

            text: 'End time:'

            onDateTimePicked: {
                console.debug(Logger.log, "endDate")
                root.end = dateTime
            }
        }
    }
}
