import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    property real borderWidth: 5
    property real sizeScale: 1

    property var filter: function(item) {
        return false
    }

    readonly property ListModel model: ListModel {}

    clip: true

    function setData(data) {

        listModel.clear()
        listView.forceLayout()

        model.clear()

        for (let item of data) {
            model.append(item)
        }

        update(true)
    }

    function setContentY(value) {
        let step = 100
        if(value > listView.contentY){
            while(listView.contentY+step<=value){
                listView.contentY += step
            }
            listView.contentY += (value - listView.contentY) % 100
        }else{
            while(listView.contentY-step>=value){
                listView.contentY -= step
            }
            listView.contentY -= (listView.contentY - value) % 100
        }
    }

    function setContentYatIndex(idx) {
        let step  =100
        setContentY(100)
        listView.forceLayout()
        while (listView.model.get(listView.indexAt(10, listView.contentY)) && listView.model.get(listView.indexAt(10, listView.contentY)).firstIdx <= idx){
            listView.contentY+=step
        }
        while (listView.model.get(listView.indexAt(10, listView.contentY)) && listView.model.get(listView.indexAt(10, listView.contentY)).firstIdx > idx){
            listView.contentY-=step
        }
    }

    function update(useLastY) {
        listModel.clear()
        listView.forceLayout()
        setContentY(0)
        let row = []
        let sumWidth = 0
        let maxHeight = 0
        let firstId = 0
        let matchedRow = -1
        for(let i = 0; i < model.count; i++) {

            const metadata = root.model.get(i).metadata
            const imageWidth = metadata.image_width * sizeScale
                    + 3 * borderWidth
            const imageHeight = metadata.image_height

            if (sumWidth + imageWidth > width) {
                listModel.append({ sub: row, maxHeight: maxHeight, firstIdx: firstId })
                firstId = i
                sumWidth = 0
                maxHeight = 0
                row = []
            }

            if(i == listView.firstIdInTheFirstRow) {
                matchedRow = listModel.count
            }

            sumWidth += imageWidth
            maxHeight = Math.max(maxHeight, imageHeight)
            row.push({ idx: i })
        }

        if (row.length > 0) {
            listModel.append({ sub: row, maxHeight: maxHeight, firstIdx: firstId })
        }
        listView.forceLayout()

        if (useLastY) {
            setContentY(listView.lastY)
        } else {
            if (matchedRow != -1) {
                setContentYatIndex(listView.firstIdInTheFirstRow)
            } else {
                setContentY(0)
            }
        }
        listView.forceLayout()

        listView.lastY = listView.contentY
    }

    onWidthChanged: timer.restart()
    onSizeScaleChanged: timer.restart()

    Timer {
        id: timer
        interval: 500
        onTriggered: root.update(false)
    }

    ListView {
        id: listView
        anchors.fill: parent
        property int lastY: 0
        property int firstIdInTheFirstRow: -1
        ScrollIndicator.vertical: ScrollIndicator { }

        model: ListModel {
            id: listModel
        }

        onMovementEnded: {
            firstIdInTheFirstRow = model.get(indexAt(10, contentY)).firstIdx
            lastY = contentY
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

                    property var item: root.model.get(modelData)

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
                                if (rect.state == "grayout")
                                    return

                                item.selected = !item.selected
                                item = root.model.get(modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
