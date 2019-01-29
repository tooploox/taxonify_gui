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
                        border.width: 4
                        color: 'lightblue'
                    }
                },
                State {
                    when: !model.selected
                    name: "basic"
                    PropertyChanges {
                        target: rect

                        border.color: 'darkblue'
                        border.width: 2
                        color: 'lightgray'
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

                Loader {
                    anchors.fill: parent

                    sourceComponent: rect.state === "grayout" ? grayout : null

                    Component {
                        id: grayout

                        Colorize {
                            source: img
                            hue: 0.0
                            saturation: 0.0
                            lightness: 0.0
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: model.selected = !model.selected
            }
        }
    }
}
