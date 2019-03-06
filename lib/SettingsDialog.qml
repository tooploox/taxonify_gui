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

    signal userListRequested()
    signal addUserRequested(string username)

    property var settingsTabs: ['Users']

    function updateUserList(data) {
        userSettings.updateUserList(data)
    }

    function addUserResponse(status) {
        userSettings.addUserResponse(status)
    }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            Layout.fillWidth: true
            height: bar.height

            TabBar {
                id: bar
                width: parent.width
                clip: true
                Repeater {
                    model: settingsTabs
                    clip: true

                    TabButton {
                        text: modelData
                        width: Math.max(100, bar.width / settingsTabs.length)
                    }
                }
            }
        }

        StackLayout {
            id: stack
            currentIndex: bar.currentIndex
            Layout.fillHeight: true
            Layout.fillWidth: true

            UserSettingsForm {
                id: userSettings
                Layout.fillHeight: true
                Layout.fillWidth: true

                onClose: root.close()
                onUserListRequested: root.userListRequested()
                onAddUserRequested: root.addUserRequested(username)
            }
        }
    }

    onAboutToShow: {
        root.userListRequested()
    }
}
