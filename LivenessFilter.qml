import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

GroupBox {
    id: gb
    property bool fillWidth: true
    property bool checked: true
    Layout.fillWidth: fillWidth

    label: CheckBox {
        id: livenessCkbx
        checked: gb.checked
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
