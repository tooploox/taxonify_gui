import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout {
    id: root
    property alias text : label.text
    property alias dateTime: dateField.dateTime
    signal dateTimePicked()

    function setBold(bold) {
        label.font.bold = bold
        dateField.textField.font.bold = bold
    }

    Label {
        id: label
    }

    DateTimeField {
        id: dateField
        Layout.fillHeight: true
        Layout.fillWidth: true
        onDateTimePicked: {
            console.debug(Logger.log, "dateField")
            root.dateTimePicked()
        }
    }
}
