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

    function updateUserList(data) {
        userSettings.updateUserList(data)
    }

    function addUserResponse(status) {
        userSettings.addUserResponse(status)
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
                id: settingsItem
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
                highlight: Rectangle {
                    color: 'whitesmoke'
                    border.color: 'lightgray'
                }
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
                onUserListRequested: root.userListRequested()
                onAddUserRequested: root.addUserRequested(username)
            }
        }
    }

    onAboutToShow: {
        content.settingsSections.append({id: "Users"})
        root.userListRequested()
    }
}
