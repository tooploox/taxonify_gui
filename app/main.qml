import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {
    id: root
    visible: true

    width: 640 * 2
    height: 480 * 1.5

    title: qsTr("Taxonify")

    readonly property var defaultSettings: ({ host: 'http://localhost' })
    readonly property string serverAddress: Util.getSettingVariable(
                                                'host', defaultSettings['host'])

    DataAccess {
        id: dataAccess
        server: new Req.Server(serverAddress)
    }

    property string currentUser: ''

    StackView {
        id: st
        anchors.fill: parent
        initialItem: loginPage
    }

    LoginPage {
        id: loginPage
        onUserLogged: st.replace(mainPage, { currentUser: username })
        StackView.onActivated: {
            console.debug(Logger.log, "LoginPage")
            usernameField.forceActiveFocus()
        }
    }

    Component {
        id: mainPage
        MainPage {
            onLogoutClicked: st.replace(loginPage)
            address: Util.getSettingVariable('host', defaultSettings['host'])
        }
    }

    Component.onCompleted: {
        console.log('using server:', serverAddress)
    }
}
