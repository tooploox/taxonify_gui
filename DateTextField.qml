import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


FocusScope {
    id: root

    height: dateTimeRow.height
    width: dateTimeRow.width

    property color dateTextColor: "black"
    property alias description: labelText.text

    readonly property alias text: textInput.text
    readonly property bool valid: !isNaN(date)
    readonly property var date: Date.fromLocaleString(
                                    locale, textInput.text, "yyyy-MM-dd")
    readonly property bool empty: (textInput.text === '--')

    RowLayout {
        id: dateTimeRow

        Text {
            id: labelText

            color: enabled ? "black" : "grey"
            Layout.preferredWidth: 80
        }

        TextInput {
            id: textInput
            color: enabled ? root.dateTextColor : "gray"
            inputMask: "9999-99-99;_"

            ToolTip.visible: activeFocus
            ToolTip.delay: 200
            ToolTip.text: qsTr("yyyy-mm-dd")

            focus: true
        }
    }
}
