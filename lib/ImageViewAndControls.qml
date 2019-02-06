import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {

    SortingControls {
        enabled: false
    }

    property alias filter: imageView.filter
    property alias images: imageView.images
    property alias update: imageView.update

    ImageView {
        id: imageView

        Layout.fillWidth: true
        Layout.fillHeight: true

        sizeScale: tileSizeSlider.value

        onWidthChanged: timer.restart()
        onSizeScaleChanged: timer.restart()

        Timer {
            id: timer
            interval: 500
            onTriggered: update(imageView.width)
        }
    }

    Rectangle {
        border.color: 'lightgray'
        Layout.fillWidth: true
        Layout.preferredHeight: 50

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Label {
                text: "Tile size:"
            }

            Slider {
                id: tileSizeSlider

                from: 0.25
                to: 2.0
                value: 1.0
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "Number of images loaded: " + images.count
            }
        }
    }
}
