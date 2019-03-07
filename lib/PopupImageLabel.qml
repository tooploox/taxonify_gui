import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Label {
    property alias source : img.source
    property int imageWidth
    property int imageHeight
    readonly property int borderWidth: 3

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            popupCloseTimer.stop()
            popup.open()
        }
        onExited: {
            popupCloseTimer.restart()
        }
    }

    Timer {
        id: popupCloseTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: {
            popup.close()
        }

    }

    Popup {
        id: popup
        parent: Overlay.ovelay
        width: 0
        height: 0
        modal: true
        dim: false

        Rectangle {
            id: content
            anchors.left: parent.left
            anchors.top: parent.top

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

                onEntered: {
                    popupCloseTimer.stop()
                }
                onExited: {
                    popupCloseTimer.restart()
                }
            }
        }
    }
}
