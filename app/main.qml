import QtQuick 2.12
import QtQuick.Controls 2.12

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
    property string currentUser: ''

    StackView {
        id: st
        anchors.fill: parent
        initialItem: loginPage
    }

    LoginPage {
        id: loginPage
        onUserLogged: (username) => {
            mainPage.currentUser = username
            st.replace(mainPage)
            mainPage.visible = true
        }
    }

    MainPage {
        id: mainPage
        visible: false
    }

    Component.onCompleted: {
        Util.settingsPath = settingsPath
        const serverAddress = Util.getSettingVariable('host', defaultSettings['host'])
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        mainPage.address = serverAddress
    }
}
