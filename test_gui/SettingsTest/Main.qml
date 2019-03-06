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
        id: settingsDialog

        onClosed: app.close()

        onUserListRequested: listUsers.call()
        onAddUserRequested: addUserRequest.call(username)


    }

    Request {
        id: login
        handler: dataAccess.login
        onError: console.log('Login failed. Details: ' + JSON.stringify(details, null, 2))
    }

    Request {
        id: listUsers
        handler: dataAccess.userList

        onSuccess: {
            let userList = res.map(item => item.username)
            settingsDialog.updateUserList(userList)
        }
    }

    Request {
        id: addUserRequest
        handler: dataAccess.addUser

        onSuccess: settingsDialog.addUserResponse(true)
        onError: settingsDialog.addUserResponse(false)
    }

    // Delay for 500ms is needed to get login procedure finished properly
    // to allow settings dialog load user list at startup
    Timer {
        id: delayShowSettings
        interval: 500
        running: true
        repeat: false
        onTriggered: settingsDialog.open()
    }

    Component.onCompleted: {
        const serverAddress = 'http://localhost'
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        const username = 'aquascopeuser'
        const password = 'hardpass'
        login.call(username, password)
        delayShowSettings.start()
    }
}
