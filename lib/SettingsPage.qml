import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


ColumnLayout {
    id: root
    property ListModel settingsSections: ListModel {}

    // Signal emmited when Main view button clicked
    signal mainView()


    Rectangle{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        border.color: 'lightgray'
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 10
            Text {
                verticalAlignment: Text.AlignVCenter
                text: '<b>Settings</b>'
            }

            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                Layout.preferredHeight: 30
                text: qsTr("Main view")
                onClicked: root.mainView()
            }
        }
    }

    RowLayout {
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
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
            }
        }


    }

    Component.onCompleted: {
        settingsSections.append({id: 'USERS'})
    }
}

