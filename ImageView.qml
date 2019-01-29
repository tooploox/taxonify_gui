import QtQuick 2.12
import QtGraphicalEffects 1.12

GridView {
    model: itemsModel

    property var filter: function(item) {
        return false
    }

    delegate: Item {

        width: cellWidth
        height: cellWidth


        Rectangle {

            id: rect

            anchors.centerIn: parent
            width: parent.width - 10
            height: parent.height - 10

            states: [
                State {
                    when: filter(model)
                    name: "grayout"
                    PropertyChanges {
                        target: rect
                        border.color: 'darkgray'
                    }
                    PropertyChanges {
                        target: img
                        opacity: 0.4
                    }
                },
                State {
                    when: !model.selected
                    name: "basic"
                    PropertyChanges {
                        target: rect

                        border.color: 'darkblue'
                        border.width: 2
                        color: 'gainsboro'
                    }
                },
                State {
                    when: model.selected
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
                id: img
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
