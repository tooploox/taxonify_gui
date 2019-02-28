import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/"

ApplicationWindow {
    id: app
    visible: true

    width: 800
    height: 500

    SettingsDialog {
        id: settings

        onClosed: app.close()
    }

    Component.onCompleted: {
        settings.open()
    }
}
