import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root

    property var model
    property alias title: titleLabel.text
    readonly property int listViewBorder: 1

    FontLoader { id: fontLoader; source: 'qrc:/graphics/Font Awesome 5 Free-Solid-900.otf'}

    RowLayout {
        Layout.fillWidth: true

        Label {
            id: titleLabel
        }

        Item {
            Layout.fillWidth: true
        }

        ToolButton {
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: qsTr('Copy to clipboard')
            contentItem: Text {
                text: '\uf0c5'
                font.family: fontLoader.name
                color: 'lightgray'
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            onClicked: {
                console.log('surprise')
            }
        }
    }

    Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        border.width: listViewBorder
        border.color: 'lightgray'
        color: 'whitesmoke'

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 2 * listViewBorder

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
