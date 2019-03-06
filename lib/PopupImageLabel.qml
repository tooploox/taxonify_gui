import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Label {
    property alias source : img.source
    property int imageWidth
    property int imageHeight
    readonly property int borderWidth: 3

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

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            popup.open()
        }
    }

    Popup {
        id: popup
        parent: Overlay.ovelay
        width: 0
        height: 0
        modal: true

        Rectangle {
            anchors.centerIn: parent
            width: img.paintedWidth + 2 * borderWidth
            height: img.paintedHeight + 2 * borderWidth
            color: 'red'

            Image {
                id: img
                anchors.centerIn: parent
                width: Math.min(300, imageWidth) - borderWidth
                height: Math.min(300, imageHeight) - borderWidth
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onExited: {
                    popup.close()
                }
            }
        }
    }
}
