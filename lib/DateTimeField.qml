import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    signal dateTimePicked()
    property alias dateTime: dateTimePicker.dateTime
    property alias textField : textField

    width: textField.width
    height: textField.height

    TextField {
        id: textField
        readOnly: true
        font.pixelSize: 14
        horizontalAlignment: TextInput.AlignHCenter
        onReleased: {
            const mappedPoint = mapToItem(Overlay.overlay, 0, 0)
            popup.x = mappedPoint.x
            popup.y = mappedPoint.y
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
                popup.close()

                if (dateTime) {
                    textField.text = dateTime.toLocaleString(Qt.locale('en_GB'), Locale.ShortFormat)
                } else {
                    textField.text = ''
                }

            }
        }
    }
}
