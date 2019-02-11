import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 50

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10

        ComboBox {
            width: 200
            model: ["Sort by date", "Sort by size", "Sort by something"]
        }

        RadioButton {
            checked: true
            text: qsTr("Ascending")
        }

        RadioButton {
            text: qsTr("Descending")
        }
    }
}
