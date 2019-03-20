import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root

    property var model
    property alias title: titleLabel.text
    readonly property int borderWidth: 1

    Label {
        id: titleLabel
    }

    Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        border.width: borderWidth
        border.color: 'lightgray'
        color: 'whitesmoke'

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 2 * borderWidth

            clip: true
            ScrollBar.horizontal: ScrollBar { active: true }
            ScrollBar.vertical: ScrollBar { active: true }
            spacing: 5

            flickableDirection: Flickable.AutoFlickIfNeeded
            boundsBehavior: Flickable.StopAtBounds

            model: root.model ? root.model : []
            delegate: Text {
                text: modelData
                onWidthChanged: {
                    if (width > listView.contentWidth) {
                        listView.contentWidth = width
                    }
                }
            }
        }
    }
}
