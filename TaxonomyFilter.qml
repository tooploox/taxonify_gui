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
        property int specifiedTill: 0 // index of last item with enabled options

        ComboBox {
            Layout.fillWidth: true
            model: getModel()
            property bool completed: false

            function getModel() {
                return index > rptr.specifiedTill ?
                            [notSpecifiedStr] :
                            [notSpecifiedStr, ...Object.keys(nodes[index])]
            }

            function update() {
                model = getModel()
                if (model[currentIndex] !== notSpecifiedStr)
                    nodes[index + 1] = nodes[index][model[currentIndex]]
                if (completed && index + 1 < taxonomyDepth)
                    rptr.itemAt(index + 1).update()
            }

            onCurrentIndexChanged: {
                if (model[currentIndex] === notSpecifiedStr) {
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
        const path = "qrc:/taxonomy_hierarchy.json"
        const request = new XMLHttpRequest
        request.open('GET', path, false)
        request.send(null)

        if (request.status === 200) {
            try {
                nodes[0] = JSON.parse(request.responseText)
                rptr.model = taxonomyDepth
            } catch(e) {
                console.warn('Error when reading json file ', path)
                console.log(e)
            }
        }
    }
}
