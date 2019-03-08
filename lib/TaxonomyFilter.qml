import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import "network/requests.js" as Requests

ColumnLayout {
    property alias container: rptr
    readonly property string notSpecifiedStr: "Not specified"

    readonly property var taxonomyNames: ItemAttributes.taxonomyAttributes

    property bool annotationMode: false
    property int taxonomyDepth: 8
    property int updateCounter: 0

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
            property alias currentIndex: combobox.currentIndex
            property alias combobox: combobox
            property alias checkbox: checkbox
            property bool updatesDisabled: false

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
                readonly property int notSpecifiedStrPosition: 0

                property bool isEmpty: model.length === 1

                property int appliedIndex: -1 // if nothing was applied then -1

                function calculateAppliedIndex() {
                    if (!isEmpty && nodes[index].time === (updateCounter - 1))
                        return nodes[index].applied
                    if (notSpecifiedLastApplied[index] === (updateCounter - 1))
                        return notSpecifiedStrPosition
                    return -1
                }

                delegate: MenuItem {
                    width: parent.width
                    text: {
                        if(!combobox.textRole) return modelData;
                        if(Array.isArray(combobox.model)) return modelData[combobox.textRole]
                        return model[combobox.textRole]
                    }
                    Material.foreground: combobox.currentIndex === index ? parent.Material.accent : parent.Material.foreground
                    highlighted: combobox.highlightedIndex === index
                    hoverEnabled: combobox.hoverEnabled
                    font.bold: combobox.appliedIndex === index
                }

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
                    return getModelForIndex(index)
                }

                function getModelForIndex(idx) {
                    return [notSpecifiedStr, ...Object.keys(nodes[idx]).sort()]
                }

                function has(object, key) {
                      return object ? hasOwnProperty.call(object, key) : false;
                }

                function fixItemState(itemIdx, value) {
                    let item = rptr.itemAt(itemIdx)

                    item.combobox.model = getModelForIndex(itemIdx)
                    let modelIdx = item.combobox.model.indexOf(value)
                    if (modelIdx !== -1) {
                        item.combobox.currentIndex = modelIdx
                        item.checked = true
                        item.checkbox.enabled = true
                    }
                }

                function fixUpperFields(itemIdx) {
                    let itemValue = rptr.itemAt(itemIdx).getValue()
                    let upperItemIdx = itemIdx - 1
                    let upperItem = rptr.itemAt(upperItemIdx)
                    let upperItemModel = getModelForIndex(upperItemIdx)
                    if (upperItem.getValue() !== notSpecifiedStr) {
                        return
                    }

                    let node = nodes[upperItemIdx]
                    for (let childNodeIdx in node) {
                        let childNode = node[childNodeIdx]
                        if (has(childNode, itemValue)) {
                            // fixing the node for itemIdx
                            nodes[itemIdx] = childNode

                            if (itemIdx > 0) {
                                let upperItemModelIdx = upperItemModel.indexOf(childNodeIdx)
                                if (upperItemModelIdx !== -1) {
                                    // set upper item to correct index and trigger changes on that level
                                    upperItem.combobox.currentIndex = upperItemModelIdx
                                    if (upperItemIdx > 0) {
                                        fixUpperFields(upperItemIdx)
                                    }
                                }
                            }
                            break
                        }
                    }
                    fixItemState(itemIdx, itemValue)
                }

                function populateLowerNode() {
                    let nextNodes = {}
                    for (let idx in model) {
                        if (idx != 0) {
                            let idxNodes = nodes[index][model[idx]]
                            nextNodes = Object.assign(nextNodes, idxNodes)
                        }
                    }
                    nodes[index + 1] = nextNodes
                }

                function resetLowerChoiceWithoutUpdate() {
                    let lowerItem = rptr.itemAt(index + 1)
                    if (lowerItem) {
                        lowerItem.updatesDisabled = true
                        lowerItem.currentIndex = 0
                        lowerItem.updatesDisabled = false
                    }
                }

                function update() {
                    model = getModel()
                    if (model[currentIndex] !== notSpecifiedStr)
                    {
                        if (index > 0) {
                            fixUpperFields(index)
                        }

                        let next_nodes = nodes[index][model[currentIndex]]
                        nodes[index + 1] = next_nodes

                        checkbox.checked = true
                        checkbox.enabled = false
                    } else {
                        populateLowerNode()
                        resetLowerChoiceWithoutUpdate()
                        checkbox.enabled = true
                    }

                    if (completed && index + 1 < taxonomyDepth)
                        rptr.itemAt(index + 1).update()

                    appliedIndex = calculateAppliedIndex()
                    font.bold = currentIndex === appliedIndex
                }

                onCurrentIndexChanged: {
                    if (updatesDisabled) {
                        return
                    }

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
