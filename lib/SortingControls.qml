import QtQuick 2.12
import QtQuick.Controls 2.12

Row {
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
