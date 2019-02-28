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
    readonly property string serverAddress: Util.getSettingVariable(
                                                'host', defaultSettings['host'])

    property string currentUser: 'aquascopeuser'
    property string password: 'hardpass'

    DataAccess {
        id: dataAccess
        server: new Req.Server(serverAddress)
    }

    Request {
        id: login
        handler: dataAccess.login
        onSuccess: {
            root.currentUser = currentUser
            loader.active = true
        }
        onError: console.log('Login failed. Details: ' + JSON.stringify(details, null, 2))
    }

    Loader {
        id: loader
        anchors.fill: parent
        active: false

        sourceComponent: MainPage {
            id: mainPage
            currentUser: root.currentUser
            address: serverAddress
        }
    }

    Component.onCompleted: {
        console.log('using server:', serverAddress)
        login.call(currentUser, password)
    }
}
