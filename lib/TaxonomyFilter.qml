import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "network/requests.js" as Requests

ColumnLayout {
    anchors.fill: parent

    readonly property string notSpecifiedStr: "Not specified"

    readonly property var taxonomyNames: [
        'empire', 'kingdom', 'phylum', 'class', 'order', 'family', 'genus',
        'species'
    ]

    property int taxonomyDepth: 8
    property var nodes: new Array(taxonomyDepth)
    property var notSpecifiedLastApplied: new Array(taxonomyDepth)

    property var criteria: {
        let crtr = {}
        for (let i = 0; i < rptr.specifiedTill; i++)
            crtr[taxonomyNames[i]] = rptr.itemAt(i).getValue().toLowerCase()
        for (let i = rptr.specifiedTill; i < taxonomyDepth; i++)
            crtr[taxonomyNames[i]] = null
        return crtr
    }

    property bool annotationMode: false

    property alias container: rptr

    property int updateCounter: 0

    function update() {
        if (updateCounter == Number.MAX_SAFE_INTEGER)
            updateCounter = 0
        updateCounter += 1
        container.itemAt(0).update()
    }

    Repeater {
        id: rptr

        model: 0
        property int specifiedTill: 0 // index of first item with "Not specified"
        RowLayout {
            property alias value: combobox.value
            property alias checked: checkbox.checked
            function getValue() {
                return combobox.getValue()
            }

            function update() {
                combobox.update()
            }

            function apply() {
                combobox.apply()
            }

            CheckBox {
                id: checkbox
                visible: !annotationMode
                checked: annotationMode
            }

            ComboBox {
                id: combobox
                Layout.fillWidth: true
                model: getModel()
                property bool completed: false
                readonly property string value: model[currentIndex]

                property bool isEmpty: model.length == 1



                function apply() {
                    if (isEmpty || model[currentIndex] === notSpecifiedStr) {
                        notSpecifiedLastApplied[index] = updateCounter
                    } else {
                        Object.defineProperty(nodes[index], 'applied', {
                                                  value: currentIndex,
                                                  configurable: true
                                              })
                        Object.defineProperty(nodes[index], 'time', {
                                                  value: updateCounter,
                                                  configurable: true
                                              })
                    }
                }

                function getValue() {
                    return model[currentIndex]
                }

                function getModel() {
                    return index > rptr.specifiedTill ?
                                [notSpecifiedStr] :
                                [notSpecifiedStr, ...Object.keys(nodes[index])]
                }

                function update() {
                    model = getModel()
                    if (model[currentIndex] !== notSpecifiedStr)
                    {
                        nodes[index + 1] = nodes[index][model[currentIndex]]
                        checkbox.checked = true
                        checkbox.enabled = false
                    } else {
                        checkbox.enabled = true
                    }

                    if (completed && index + 1 < taxonomyDepth)
                        rptr.itemAt(index + 1).update()

                    if (isEmpty) {
                        font.bold = notSpecifiedLastApplied[index] == (updateCounter - 1)
                    } else {
                        const sameIndexAsRecentlyApplied = nodes[index].applied === currentIndex
                        const sameCheckboxUsedRecently = nodes[index].time == (updateCounter - 1)
                        const notSpecifiedChosen = model[currentIndex] === notSpecifiedStr
                        const notSpecifiedApplied = notSpecifiedLastApplied[index] == (updateCounter - 1)
                        font.bold = (sameIndexAsRecentlyApplied && sameCheckboxUsedRecently) ||
                                    (notSpecifiedChosen && notSpecifiedApplied)
                    }
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
    }

    Component.onCompleted: {
        let tree = Requests.readJsonFromLocalFileSync("qrc:/taxonomy_hierarchy.json")
        if (tree) {
            nodes[0] = tree
            rptr.model = taxonomyDepth
        }
    }
}
