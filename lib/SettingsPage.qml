import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12


ColumnLayout {
    id: root
    property ListModel settingsSections: ListModel {}

    // Signal emmited when Main view button clicked
    signal mainView()

    RowLayout {
        Text {
            Layout.leftMargin: 10
            Layout.topMargin: 5

            verticalAlignment: Text.AlignHCenter
            text: '<b>Settings</b>'
        }

        Item {
            Layout.fillWidth: true
        }

        ToolButton {
            Layout.preferredHeight: 30
            Layout.rightMargin: 10
            Layout.topMargin: 5
            text: qsTr("Main view")
            onClicked: root.mainView()
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.bottomMargin: 2

        border.width: 1
        height: 2

        border.color: "gainsboro"
    }

    RowLayout {
        ListView {
            Layout.fillHeight: true
            Layout.margins: 10
            Layout.preferredWidth: 80
            model: settingsSections
            delegate: Text {
                text: { '<b>' + id + '</b>' }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.topMargin: 2
            Layout.leftMargin: 2

            border.width: 1
            height: 2

            border.color: "gainsboro"
        }

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

