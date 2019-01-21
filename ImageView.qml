import QtQuick 2.12

GridView {
    id: grid

    cellWidth: 100 + tileSizeSlider.value * 150
    cellHeight: 100 + tileSizeSlider.value * 150

    model: itemsModel

    delegate: Item {

        width: grid.cellWidth
        height: grid.cellWidth

        Rectangle {

            id: rect

            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10

            state: model.selected ? 'selected' : 'basic'

            states: [
                State {
                    name: "basic"
                    PropertyChanges {
                        target: rect

                        border.color: 'darkblue'
                        border.width: 2
                        color: 'lightgray'
                    }
                },
                State {
                    name: "selected"
                    PropertyChanges {
                        target: rect

                        border.color: 'red'
                        border.width: 4
                        color: 'lightblue'
                    }
                }
            ]

            Image {
                width: parent.width - 10
                height: parent.height - 10

                fillMode: Image.PreserveAspectFit

                anchors.centerIn: parent

                source: image
                clip: true
            }

            MouseArea {
                anchors.fill: parent

                onClicked: model.selected = !model.selected
            }
        }
    }
}
