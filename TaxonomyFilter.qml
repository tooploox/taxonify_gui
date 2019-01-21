import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    anchors.fill: parent

    property var names: [
        ["Prokaryota", "Eukaryota"],
        ["Bacteria", "Chromista"],
        ["Chrysophyceae", "Bicosea"],
        ["Nostocales", "Oscillatoriales"],
        ["Coelosphaeriaceae", "Gomphosphaeriaceae", "Microcystaceae"],
        ["Aphanothece", "Chroococcus"]
    ]

    Repeater {

        model: root.names.length

        ComboBox {
            Layout.fillWidth: true
            model: root.names[index]
        }
    }
}
