import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


ColumnLayout {
    id: root
    property ListModel settingsSections: ListModel {}

    // Signal emmited when Main view button clicked
    signal mainView()

    function refreshUserList() {
        userSettings.refreshUserList()
    }

    Rectangle{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        border.color: 'lightgray'

        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: '<b>Settings</b>'
        }
    }

    RowLayout {
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            border.color: 'lightgray'

            ListView {
                id: settingsList
                anchors.fill: parent
                anchors.topMargin: 10
                model: settingsSections
                delegate: ColumnLayout {
                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        rightPadding: 2
                        text: { '<b>' + id + '</b>' }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        Layout.preferredWidth: settingsList.width - 5
                        Layout.leftMargin: 2
                        Layout.rightMargin: 2

                        color: 'lightgray'
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10

            UserSettingsForm {
                id: userSettings
                anchors.fill: parent

                onClose: root.mainView()
            }
        }


    }

    Component.onCompleted: {
        settingsSections.append({id: 'USERS'})
    }
}

