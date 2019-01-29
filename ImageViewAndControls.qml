import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    SortingControls {}

    property alias filter: imageView.filter

    ImageView {
        id: imageView
        clip: true

        cellWidth: 100 + tileSizeSlider.value * 150
        cellHeight: 100 + tileSizeSlider.value * 150

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    Rectangle {
        border.color: 'lightgray'
        Layout.fillWidth: true
        Layout.preferredHeight: 50

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10

            Label {
                text: "Tile size:"
            }

            Slider {
                id: tileSizeSlider
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }
}
