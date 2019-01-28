import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

GroupBox {
    id: gb
    property alias checkBoxChecked: livenessCkbx.checked
    property bool isAnnotationMode: false

    label: CheckBox {
        id: livenessCkbx
        checked: true
        text: qsTr("Liveness")
    }

    ColumnLayout {
        anchors.fill: parent
        enabled: livenessCkbx.checked

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
}
