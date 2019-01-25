import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

GroupBox {
    id: gb
    property bool checkBoxChecked: true

    label: CheckBox {
        id: livenessCkbx
        checked: gb.checkBoxChecked
        text: qsTr("Liveness")
    }

    ColumnLayout {
        anchors.fill: parent
        enabled: livenessCkbx.checked
        CheckBox { text: qsTr("Alive") }
        CheckBox { text: qsTr("Dead") }
        CheckBox { text: qsTr("Not specified") }
    }
}
