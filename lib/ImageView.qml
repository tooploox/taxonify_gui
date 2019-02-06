import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property var model

    property alias images: root.model
    property alias update: listModel.update

    property real borderWidth: 5
    property real sizeScale: 1

    property var filter: (item) => false

    clip: true

    ListView {
        id: listView
        anchors.fill: parent

        ScrollBar.vertical: ScrollBar {}

        ListModel {
            id: listModel

            property real maxWidth: root.width

            property var update: function () {
                clear()

                let row = []
                let sumWidth = 0
                let maxHeight = 0

                for(let i = 0; i < images.count; i++) {

                    const metadata = images.get(i).metadata
                    const imageWidth = metadata.image_width * sizeScale
                            + 3 * borderWidth
                    const imageHeight = metadata.image_height

                    if(sumWidth + imageWidth > maxWidth) {
                        append({ sub: row, maxHeight: maxHeight })
                        sumWidth = 0
                        maxHeight = 0
                        row = []
                    }

                    sumWidth += imageWidth
                    maxHeight = Math.max(maxHeight, imageHeight)
                    row.push({ idx: i })
                }

                if(row.length > 0) {
                    append({ sub: row, maxHeight: maxHeight })
                }

                listView.model = listModel
            }
        }

        delegate: Rectangle {
            id: rowRect
            height: maxHeight * sizeScale + 3 * borderWidth
            width: parent.width

            ListView {
                anchors.fill: parent
                orientation: Qt.Horizontal
                clip: true

                model: sub

                ScrollBar.horizontal: ScrollBar {}

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
