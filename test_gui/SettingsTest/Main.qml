import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/"
import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {
    id: app
    visible: true

    width: 800
    height: 500

    property var dataAccess: DataAccess {}

    SettingsDialog {
        id: settings

        onClosed: app.close()
    }

    Request {
        id: login
        handler: dataAccess.login
        onError: console.log('Login failed. Details: ' + JSON.stringify(details, null, 2))
    }

    Component.onCompleted: {
        const serverAddress = 'http://localhost'
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        const username = 'aquascopeuser'
        const password = 'hardpass'
        login.call(username, password)
        settings.open()
    }
}
