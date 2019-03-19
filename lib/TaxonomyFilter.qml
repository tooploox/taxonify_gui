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

    function updateBoldness() {
        if (updateCounter == Number.MAX_SAFE_INTEGER)
            updateCounter = 0
        updateCounter += 1
        for (let d = 0 ; d< taxonomyDepth; d++){
            let appliedIndex = container.itemAt(d).combobox.calculateAppliedIndex()
            container.itemAt(d).combobox.font.bold = d === appliedIndex
        }
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

                function searchDownTheTree(value, currentDepth, maxDepth, branch) {
                    let currentItem = rptr.itemAt(currentDepth)
                    let currentValue = currentItem.getValue()

                    if (currentDepth == maxDepth) {
                        for (const subcategory of Object.keys(branch)) {
                            if (subcategory == value) {
                                return [subcategory]
                            }
                        }
                        return null
                    }

                    if (currentValue !== notSpecifiedStr) {
                        let subbranch = branch[currentValue]
                        let path = searchDownTheTree(value, currentDepth+1, maxDepth, subbranch)
                        return [currentValue, ...path]
                    } else {
                        for (const subcategoryEntry of Object.entries(branch)) {
                            let subcategory = subcategoryEntry[0]
                            let subbranch = subcategoryEntry[1]
                            let path = searchDownTheTree(value, currentDepth+1, maxDepth, subbranch)
                            if (path) {
                                return [subcategory, ...path]
                            }
                        }
                        return false
                    }
                }

                //this sets the path returned by searchDownTheTree
                function setPath(path, currentDepth) {
                    const [value, ...tail] = path;
                    setValue(value, currentDepth)
                    if (tail.length) {
                        setPath(tail, currentDepth+1)
                    }
                }

                //this is the entry point for taxonomy bypass logic
                function fixUpperFields(itemIdx) {
                    let itemValue = rptr.itemAt(itemIdx).getValue()
                    let path = searchDownTheTree(itemValue, 0, itemIdx, nodes[0])
                    setPath(path, 0)
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

                function setCheckbox(checkbox, checked, enabled) {
                    checkbox.checked = checked
                    checkbox.enabled = enabled
                }

                function setValue(value, depth) {
                    let item = rptr.itemAt(depth)
                    if (item) { // can be null during initialisation
                        let valueIdx = item.combobox.model.indexOf(value)
                        item.combobox.currentIndex = valueIdx
                    }
                }

                function setNextModel() {
                    let item = rptr.itemAt(index + 1)
                    if (item) {
                        let model = getModelForIndex(index + 1)
                        let model_before = item.combobox.model
                        item.combobox.model = model
                        if (model_before != model) {
                            item.combobox.currentIndexChanged() // this triggers cascade of updates if value did not change but the model did
                            setValue(notSpecifiedStr, index + 1)
                        }
                    }
                }

                function update() {
                    if (model[currentIndex] !== notSpecifiedStr) {
                        if (index > rptr.specifiedTill) { // only if "Not Specified" is currently selected above
                            fixUpperFields(index)
                        }
                        if (index === rptr.specifiedTill) {
                            rptr.specifiedTill++
                        }

                        let next_nodes = nodes[index][model[currentIndex]]
                        nodes[index + 1] = next_nodes
                        setNextModel()
                        setCheckbox(checkbox, true, false) // by default we check and disable checkboxes next to concrete values
                    } else {
                        populateLowerNode()
                        setNextModel()
                        setValue(notSpecifiedStr, index+1)
                        rptr.specifiedTill = Math.min(rptr.specifiedTill, index)
                        setCheckbox(checkbox, false, true) // by default we uncheck and enable checkboxes next to Not Specified values
                    }

                    appliedIndex = calculateAppliedIndex()
                    font.bold = currentIndex === appliedIndex
                }

                onCurrentIndexChanged: {
                    if (updatesDisabled) {
                        return
                    }

                    update()
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
        rptr.itemAt(0).combobox.currentIndexChanged()
    }
}
