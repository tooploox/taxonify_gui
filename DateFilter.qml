import QtQuick 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property alias start: startDateField
    property alias end: endDateField
    property bool valid: (start.valid && end.empty) ||
                         (start.empty && end.valid) ||
                         (start.valid && end.valid &&
                          (end.date - start.date >= 0))
    DateTextField {
        id: startDateField
        deltaMilliseconds: 0 // 00:00:00.000
        description: qsTr("Start date:")
        enabled: parent.enabled
        dateTextColor: (parent.valid || empty) ? 'black' : 'red'
    }

    DateTextField {
        id: endDateField
        deltaMilliseconds: 24*60*60*1000-1 // 23:59:59.999
        description: qsTr("End date:")
        enabled: parent.enabled
        dateTextColor: (parent.valid || empty) ? 'black' : 'red'

    }
}
