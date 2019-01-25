import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    anchors.fill: parent

    property int taxonomyDepth: 8
    property var nodes: new Array(taxonomyDepth)
    property string notSpecifiedStr: "Not specified"

    Repeater {
        id: rptr
        model: 0
        property int specifiedTill: 0

        ComboBox {
            editable: false
            Layout.fillWidth: true
            model: getModel()
            property bool completed: false

            function getModel() {
                return index > rptr.specifiedTill ?
                            [root.notSpecifiedStr] :
                            [root.notSpecifiedStr].concat(Object.keys(nodes[index]))
            }

            function update() {
                model = getModel()
                if (model[currentIndex] !== root.notSpecifiedStr)
                    nodes[index+1] = nodes[index][model[currentIndex]]
                if (completed && index+1 < taxonomyDepth)
                    rptr.itemAt(index+1).update()
            }

            onCurrentIndexChanged: {
                if (model[currentIndex] === root.notSpecifiedStr) {
                    rptr.specifiedTill = Math.min(rptr.specifiedTill, index)
                } else if (rptr.specifiedTill === index) {
                    rptr.specifiedTill++
                }
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
