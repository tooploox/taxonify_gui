import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    signal dateTimePicked()
    property alias dateTime: dateTimePicker.dateTime
    property alias textField : textField

    width: textField.width
    height: textField.height

    function setPopupPosition() {
        const mappedPoint = mapToItem(Overlay.overlay, 0, 0)
        const margin = 20

        const mostRightX = mappedPoint.x + dateTimePicker.width
        if (mostRightX + margin > Overlay.overlay.width) {
            mappedPoint.x -= mostRightX + margin - Overlay.overlay.width
        }

        const mostBottomY = mappedPoint.y + dateTimePicker.height
        if (mostBottomY + margin > Overlay.overlay.height) {
            mappedPoint.y -= mostBottomY + margin - Overlay.overlay.height
        }

        popup.x = mappedPoint.x
        popup.y = mappedPoint.y
    }

    TextField {
        id: textField
        readOnly: true
        font.pixelSize: 14
        horizontalAlignment: TextInput.AlignHCenter
        onReleased: {
            setPopupPosition()
            popup.open()
        }
    }

    Popup {
        id: popup
        parent: Overlay.overlay
        width: 0
        height: 0
        modal: true

        DateTimePicker {
            id: dateTimePicker
            onDateTimePicked: {
                console.debug(Logger.log, "dateTimePicker")
                popup.close()
                if (dateTime) {
                    textField.text = dateTime.toLocaleString(Util.locale, Locale.ShortFormat)
                } else {
                    textField.text = ''
                }
            }
        }
    }
}
