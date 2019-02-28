import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"
import "qrc:/."
import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {

    id: root
    visible: true

    width: 640 * 2
    height: 480 * 1.5

    title: qsTr("Aquascope Data Browser")

    readonly property var defaultSettings: ({ host: 'http://localhost' })
    property var dataAccess: DataAccess {}
    property string currentUser: 'aquascopeuser'
    property string password: 'hardpass'

    Request {
        id: login
        handler: dataAccess.login
        onSuccess: {
            mainPage.currentUser = currentUser
            mainPage.visible = true
        }
        onError: console.log('Login failed. Details: ' + JSON.stringify(details, null, 2))
    }

    MainPage {
        anchors.fill: parent
        id: mainPage
        visible: false
    }

    Component.onCompleted: {
        Util.settingsPath = settingsPath
        const serverAddress = Util.getSettingVariable('host', defaultSettings['host'])
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        mainPage.address = serverAddress
        login.call(currentUser, password)
    }
}
