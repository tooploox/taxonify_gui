import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: settingsDialog

    Column {
        Label {
            text: "Settings"
        }
        Row {
            ListView {

            }

            Item {
                id: settingsPane

                UserSettingsForm {
                    id: userSettings
                }
            }
        }
    }
}
