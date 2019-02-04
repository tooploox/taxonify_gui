import QtQuick 2.12
import QtQuick.Controls 2.12

ListView {
    id: root
    property alias images: root.model
    property alias update: listModel.update

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
                    var imageWidth = images.get(i).metadata.image_width
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

                    property var item: images.get(modelData)

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
                                border.width: 2
                                color: 'lightgray'
                            }
                        },
                        State {
                            when: item.selected
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
                        source: item.image

                        Component.onCompleted: {
                            const imgHeight = item.metadata.image_height
                            rowRect.height = Math.max(rowRect.height, imgHeight)
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
