import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property bool isAnnotationMode: false

    ButtonGroup { id: radioGroup }

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
