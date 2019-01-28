import QtQuick 2.0

FocusScope {
    id: root

    height: dateColumn.height
    width: dateColumn.width
    implicitWidth: dateColumn.implicitWidth
    implicitHeight: dateColumn.implicitHeight

    property alias valid: dateColumn.valid
    property alias onTabNavigateTo: dateColumn.onTabNavigateTo

    Column {
        id: dateColumn

        property bool valid: (startDateField.valid && endDateField.empty) ||
                             (startDateField.empty && endDateField.valid) ||
                             (startDateField.valid && endDateField.valid &&
                              (endDateField.date - startDateField.date >= 0))
        property var onTabNavigateTo: null

        DateTextField {
            id: startDateField

            focus: true
            description: qsTr("Start date:")
            enabled: parent.enabled
            dateTextColor: (parent.valid || empty) ? 'black' : 'red'
            KeyNavigation.tab: endDateField
        }

        DateTextField {
            id: endDateField

            description: qsTr("End date:")
            enabled: parent.enabled
            dateTextColor: (parent.valid || empty) ? 'black' : 'red'
            KeyNavigation.tab: onTabNavigateTo
        }
    }
}
