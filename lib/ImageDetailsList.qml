import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property var detailsArray
    property alias title: aggregateCheckBox.text
    property bool groupUpdatePending: false

    function pickedAttributes() {
        let picked = []
        for (let i = 0; i < itemList.model.count; i++) {
            let item = itemList.model.get(i)
            if (item.attr_checked) {
                picked.push(item.name)
            }
        }
        return picked
    }

    function modelFromArray(arr) {
        let model = arr.map(item => ({name: item, attr_checked: true}))
        return model
    }

    function updateAggregateCheckbox() {
        console.debug(Logger.log, "")
        let checked = 0
        let unchecked = 0
        for (let i = 0; i < itemList.model.count; i++) {
            let item = itemList.model.get(i)
            if (item.attr_checked) {
                checked++
            } else {
                unchecked++
            }
        }

        if (checked === itemList.model.count) {
            aggregateCheckBox.checkState = Qt.Checked
        } else if (unchecked === itemList.model.count) {
            aggregateCheckBox.checkState = Qt.Unchecked
        } else {
            aggregateCheckBox.checkState = Qt.PartiallyChecked
        }
    }

    function setGroupState(checkState) {
        console.debug(Logger.log, "checkState=" + checkState)
        let checked = checkState == Qt.Checked ? true : false
        for (let i = 0; i < itemList.model.count; i++) {
            itemList.model.setProperty(i, 'attr_checked', checked)
        }
    }

    CheckBox {
        id: aggregateCheckBox
        Layout.fillWidth: true
        Layout.bottomMargin: 10
        tristate: true
        font.bold: true

        nextCheckState: function() {
            if (checkState === Qt.Checked) {
                return Qt.Unchecked
            }
            return Qt.Checked
        }
        checkState: Qt.Checked
        onCheckStateChanged: {
            if (checkState === Qt.PartiallyChecked) {
                return
            }

            groupUpdatePending = true
            setGroupState(checkState)
            groupUpdatePending = false
        }

    }
    ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        ListView {
            id: itemList
            clip: true
            anchors.fill: parent
            model: ListModel {
                Component.onCompleted: {
                    modelFromArray(detailsArray).map(item => append(item))
                }
            }
            delegate: CheckBox {
                id: attributeCheckbox
                checked: attr_checked
                text: name
                height: 40

                onCheckedChanged: {
                    attr_checked = checked
                    if (!groupUpdatePending) {
                        updateAggregateCheckbox()
                    }
                }
            }
        }
    }
}
