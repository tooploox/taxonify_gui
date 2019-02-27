import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"
import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {

    id: root
    visible: true

    width: 640 * 2
    height: 480 * 1.5

    title: qsTr("Aquascope Data Browser")

    readonly property var defaultSettings: ({ host: 'http://localhost' })

    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    function getSettingVariable(key) {
        if(settingsFromFile) {
            if (settingsFromFile && settingsFromFile[key]) {
                return settingsFromFile[key]
            } else {
                console.log('No"' + key + '" field found in settings.')
            }
        } else {
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultSettings[key]) {
            return defaultSettings[key]
        } else {
            console.log('key ' + key
                        + ' not found in dafaults array. Returning null')
            return null
        }
    }

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
        const serverAddress = getSettingVariable('host')
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        login.call(currentUser, password)
    }
}
