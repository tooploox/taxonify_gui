import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    property bool isAnnotationMode: false
    property string value: ''

    ButtonGroup {
        id: radioGroup

        onCheckedButtonChanged: {
            root.value = checkedButton.text
        }
    }

    Repeater {
        model: [qsTr("Alive"), qsTr("Dead"), qsTr("Not specified")]

        delegate: Loader {
            sourceComponent: isAnnotationMode ?  radioBtn : checkBox

            Component {
                id: checkBox
                CheckBox { text: model.modelData }
            }

            Component {
                id: radioBtn
                RadioButton {
                    text: model.modelData;
                    ButtonGroup.group: radioGroup
                }
            }
        }
    }
}
