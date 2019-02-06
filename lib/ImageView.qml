import QtQuick 2.12
import QtQuick.Controls 2.12

ListView {
    id: root
    property alias images: root.model
    property alias update: listModel.update

    property real borderWidth: 5
    property real sizeScale: 1

    property var filter: function(item) {
        return false
    }

    ScrollBar.vertical: ScrollBar {}

    ListView {
        id: listView
        anchors.fill: parent

        model: 0

        ListModel {
            id: listModel

            property real maxWidth: root.width

            property var update: function () {
                clear()
                var row = []

                for(var i = 0, sumWidth=0; i < images.count; i++) {
                    var imageWidth = images.get(i).metadata.image_width * sizeScale + 3 * borderWidth
                    if(sumWidth + imageWidth > maxWidth) {
                        append({sub: row})
                        sumWidth = 0
                        row = []
                    }
                    sumWidth += imageWidth
                    row.push({idx: i})
                }
                if(row.length > 0) {
                    append({sub: row})
                }
                listView.model = listModel
            }
        }

        delegate: Rectangle {
            id: rowRect
            height: absoluteHeight * sizeScale + 3 * borderWidth
            width: parent.width
            //color: 'black'

            property real absoluteHeight: 0

            ListView {
                anchors.fill: parent
                orientation: Qt.Horizontal

                model: sub

                delegate: Item {
                    width: img.width + 3 * borderWidth
                    height: img.height + 3 * borderWidth

                    property var item: images.get(modelData)

                    Rectangle {
                        id: rect

                        anchors.centerIn: parent
                        width: parent.width - borderWidth
                        height: parent.height - borderWidth
                        states: [
                            State {
                                when: filter(item)
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
                                when: !item.selected
                                name: "basic"

                                PropertyChanges {
                                    target: rect

                                    border.color: 'darkblue'
                                    border.width: borderWidth / 2
                                    color: 'lightgray'
                                }
                            },
                            State {
                                when: item.selected
                                name: "selected"
                                PropertyChanges {
                                    target: rect

                                    border.color: 'red'
                                    border.width: borderWidth
                                    color: 'lightblue'
                                }
                            }
                        ]

                        Image {
                            id: img
                            source: item.image
                            anchors.centerIn: parent

                            height: item.metadata.image_height * sizeScale
                            width: item.metadata.image_width * sizeScale

                            Component.onCompleted: {
                                rowRect.absoluteHeight = Math.max(rowRect.absoluteHeight, item.metadata.image_height)
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                item.selected = !item.selected
                                item = images.get(modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
