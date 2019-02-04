import QtQuick 2.12
import QtQuick.Controls 2.12

ListView {

    property var filter: function(item) {
        return false
    }

    ScrollBar.vertical: ScrollBar {}

    delegate: Rectangle {
            id: rowRect
            height: 0
            width: parent.width
            color: 'black'

            ListView {
                anchors.fill: parent
                orientation: Qt.Horizontal

                model: sub

                delegate: Rectangle {
                    id: rect

                    width: img.width
                    height: img.height

                    states: [
                        State {
                            when: filter(model)
                            name: "grayout"

                            PropertyChanges {
                                target: img
                                opacity: 0.4
                            }
                            PropertyChanges {
                                target: rect
                                border.color: 'darkblue'
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
                        source: image

                        Component.onCompleted: {
                            rowRect.height = Math.max(rowRect.height, sourceSize.height)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: model.selected = !model.selected
                    }
                }
         }
    }
}
