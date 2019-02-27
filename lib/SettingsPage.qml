import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    property ListModel settingsSections: ListModel {}

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        color: "ghostwhite"
        Text {
            anchors.fill: parent
            anchors.margins: 10
            verticalAlignment: Text.AlignHCenter
            text: '<b>Settings</b>'
        }
    }

    RowLayout {
//            spacing: 6
        ListView {
            Layout.fillHeight: true
            Layout.preferredWidth: 80
            Layout.margins: 5
            model: settingsSections
            delegate: Text {
                text: { '<b>' + id + '</b>' }
            }
        }

//            Rectangle {
//                id: settingsView
//                Layout.fillHeight: true
//                Layout.fillWidth: true

//                Layout.minimumHeight: 400
//                Layout.minimumWidth: 400
//                color: "gainsboro"
//            }

        UserSettingsForm {
            id: userSettings
            Layout.fillHeight: true
            Layout.fillWidth: true

            Layout.minimumHeight: 400
            Layout.minimumWidth: 400

        }
    }

    Component.onCompleted: {
        settingsSections.append({id: 'Users'})
    }
}

