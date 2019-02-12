import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property bool annotationMode: false
    property alias container: rptr
    property string value: ''

    property var criteria: {
        if (value === "Dead")
            return { dead: true }
        else if (value === "Alive")
            return { dead: false }
        return { dead: null }
    }

    property var applied: []

    function apply(checked) {
        applied = []
        for (let i = 0; i < 3; i++) {
            let item = container.itemAt(i).item
            if (item.checked)
                applied.push(item.text)
            item.font.bold = checked && item.checked
        }
    }

    ButtonGroup {
        id: radioGroup

        onCheckedButtonChanged: {
            value = checkedButton.text
        }
    }

    Repeater {
        id: rptr
        model: [qsTr("Alive"), qsTr("Dead"), qsTr("Not specified")]

        delegate: Loader {
            sourceComponent: annotationMode ?  radioBtn : checkBox
            Component {
                id: checkBox
                CheckBox {
                    text: model.modelData
                    checked: true
                }
            }

            Component {
                id: radioBtn
                RadioButton {
                    text: model.modelData;
                    checked: true

                    ButtonGroup.group: radioGroup
                }
            }
        }
    }
}
