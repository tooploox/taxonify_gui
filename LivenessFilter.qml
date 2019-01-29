import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    property bool isAnnotationMode: false
    property alias container: rptr
    ButtonGroup { id: radioGroup }

    Repeater {
        id: rptr
        model: isAnnotationMode ?
                   [qsTr("Alive"), qsTr("Dead"), qsTr("Not specified")] :
                   [qsTr("Alive"), qsTr("Dead")]

        delegate: Loader {
            sourceComponent: isAnnotationMode ?  radioBtn : checkBox
            Component {
                id: checkBox
                CheckBox {
                    id: cb
                    text: model.modelData
                }
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
