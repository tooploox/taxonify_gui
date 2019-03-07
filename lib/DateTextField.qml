import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RowLayout {
    property color dateTextColor: "black"
    property alias description: labelText.text

    readonly property alias text: textInput.text
    readonly property bool valid: !isNaN(date)
    readonly property var date: Date.fromLocaleString(
                                    locale, textInput.text, "yyyy-MM-dd")
    readonly property bool empty: (textInput.text === '--' || textInput.text.length == 0)
    property string isostring: ''
    property int deltaMilliseconds: 0

    function getTimeAndApply(discard) {
        console.log(Logger.debug, "DateTextField: getTimeAndApply(discard='" + discard + "')")
        if (discard || empty) {
            console.log(Logger.debug, "DateTextField: discard or empty")
            textInput.placeholderText = "____-__-__"
            labelText.font.bold = false
            return undefined
        } else {
            console.log(Logger.debug, "DateTextField: not (discard or empty)")
            textInput.placeholderText = text
            labelText.font.bold = true
            return isostring
        }
    }

    Text {
        id: labelText

        color: enabled ? "black" : "grey"
        Layout.preferredWidth: 80

    }

    TextField {
        id: textInput

        color: enabled ? parent.dateTextColor : "gray"
        placeholderText: "____-__-__"
        inputMask: activeFocus || !empty ? "9999-99-99;_" : ""

        horizontalAlignment: TextInput.AlignHCenter

        ToolTip.visible: cursorVisible
        ToolTip.delay: 200
        ToolTip.text: qsTr("yyyy-mm-dd")
        ToolTip.toolTip.x: textInput.width + 2
        ToolTip.toolTip.y: (textInput.height - ToolTip.toolTip.height) / 2

        onEditingFinished: {
            console.log(Logger.debug, "DateTextField: Editing finished")
            if (valid) {
                console.log(Logger.debug, "DataAccess: valid date")
                date.setUTCMilliseconds(deltaMilliseconds)
                isostring = date.toISOString()
            }
        }
    }
}
