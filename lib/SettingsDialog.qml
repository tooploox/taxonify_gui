import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


Dialog {
    id: root

    modal: true
    width: 500
    height: 400

    parent: ApplicationWindow.overlay

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    title: qsTr("Settings")

    function refreshUserList() {
        userSettings.refreshUserList()
    }

    contentItem: RowLayout {
        id: content
        property ListModel settingsSections: ListModel {}

        Rectangle {
            border.color: 'lightgray'
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            Layout.maximumWidth: 100

            ListView {
                model: content.settingsSections
                delegate: Component {
                    Item {
                        width: 80; height: 40
                        Text {
                            anchors.centerIn: parent
                            text: '<b>' + id + '</b> '
                        }
                    }
                }
                highlight: Rectangle { color: 'whitesmoke'; radius: 2 }
                focus: true
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 10

            UserSettingsForm {
                id: userSettings
                anchors.fill: parent

                onClose: root.close()
            }
        }
    }

    onAboutToShow: {
        content.settingsSections.append({id: "Users"})
        root.refreshUserList()
    }
}