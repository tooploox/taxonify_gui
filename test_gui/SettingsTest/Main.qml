import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/"

ApplicationWindow {
    id: app
    visible: true

    width: 800
    height: 500

    SettingsPage {
        id: settings
        anchors.fill: parent

        onMainView: app.close()
    }
}