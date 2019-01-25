import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    anchors.fill: parent

    property int taxonomyDepth: 8
    property var nodes: new Array(taxonomyDepth)

    Repeater {
        id: rptr
        model: 0

        ComboBox {
            Layout.fillWidth: true
            model: Object.keys(nodes[index])
            property bool completed: false

            function update() {
                model = Object.keys(nodes[index])
                nodes[index+1] = nodes[index][model[currentIndex]]
                if (completed && index+1 < taxonomyDepth)
                    rptr.itemAt(index+1).update()
            }

            onCurrentIndexChanged: {
                update()
                completed = true
            }
        }
    }

    Component.onCompleted: {
        var rawFile = new XMLHttpRequest();
        rawFile.open("GET", "file:///home/stafik/proto-aquascope/taxonomy_hierarchy.txt", false);
        rawFile.onreadystatechange = function ()
        {
            nodes[0] = JSON.parse(rawFile.responseText);
        }
        rawFile.send(null);
        rptr.model = taxonomyDepth
    }
}
