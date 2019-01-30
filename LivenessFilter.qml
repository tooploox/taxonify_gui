import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property bool isAnnotationMode: false
    property alias container: rptr
    property string value: ''

    property var criteria: {
        if (value === "Dead")
            return { dead: true }
        else if (value === "Alive")
            return { dead: false }
        return { dead: null }
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
            sourceComponent: isAnnotationMode ?  radioBtn : checkBox
            Component {
                id: checkBox
                CheckBox {
                    id: cb
                    text: model.modelData
                    checked: true
                }
            }

            Component {
                id: radioBtn
                RadioButton {
                    text: model.modelData;
                    ButtonGroup.group: radioGroup
                    checked: true
                }
            }
        }
    }
}
