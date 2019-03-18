import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import com.microscopeit 1.0

ColumnLayout {
    id: root

    Rectangle{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        border.color: 'lightgray'
        RowLayout{
            anchors.fill: parent

            SortingControls {
                Layout.leftMargin: 5
                enabled: false
            }
        }
    }

    property alias hoveredItem: imageView.hoveredItem
    property alias rightClickedItem: imageView.rightClickedItem
    property alias filter: imageView.filter
    property bool pageLoadingInProgress: false
    readonly property ImageView imageView: imageView
    signal atPageBottom()
    signal itemHovered()
    signal itemRightClicked()

    ImageView {
        id: imageView

        Layout.fillWidth: true
        Layout.fillHeight: true

        sizeScale: tileSizeSlider.value

        onReachedBottom: {
            console.debug(Logger.log, "imageView")
            atPageBottom()
        }

        onItemHovered: root.itemHovered()

        onItemRightClicked: {
            console.debug(Logger.log, "imageView")
            root.itemRightClicked()
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
                stepSize: 0.05
            }

            Label {
                text: "("+ Math.round(tileSizeSlider.value * 100) +"%)"
            }

            Item {
                Layout.fillWidth: true
            }

            BusyIndicator {
                running: pageLoadingInProgress
                Layout.preferredHeight: 50
                Layout.rightMargin: 20
            }

            Label {
                text: "Images loaded: " + imageView.model.count
                Layout.rightMargin: 20
            }

            Label {
                text: "Images selected: " + imageView.selectedCount
            }
        }
    }
}
