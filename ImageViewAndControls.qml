import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {

    SortingControls {}

    ImageView {
        id: grid

        clip: true

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
