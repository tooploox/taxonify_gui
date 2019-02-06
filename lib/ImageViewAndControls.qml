import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {

    SortingControls {
        enabled: false
    }

    property alias filter: imageView.filter
    property alias model: imageView.model
    property alias update: imageView.update

    ImageView {
        id: imageView

        Layout.fillWidth: true
        Layout.fillHeight: true

        onWidthChanged: timer.restart()

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
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "Number of images loaded: " + model.count
            }
        }
    }
}
