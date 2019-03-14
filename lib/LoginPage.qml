import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import 'qrc:/network'

Item {
    id: root

    //signal userLogged is emitted after a successful login
    signal userLogged(string username)

    property alias usernameField: usernameField
    property alias username: usernameField.text
    property alias password: passwordField.text
    property alias errorMsg: errorLabel.text
    property alias loginButton : loginButton

    property bool loginInProgress: false

    function clean() {
        console.debug(Logger.log, "")
        username = ''
        password = ''
        errorMsg = ''
        loginInProgress = false
    }

    function tryLogin() {
        console.debug(Logger.log, "")
        if(username.length == 0 || password.length == 0) return
        loginInProgress = true
        console.log("Username: " + username)
        loginRequest.call(username, password)
    }

    Request {
        id: loginRequest
        handler: dataAccess.login

        onSuccess: {
            console.debug(Logger.log, "loginRequest")
            root.userLogged(username)
            clean()
        }

        onError: {
            console.debug(Logger.log, "loginRequest")
            loginInProgress = false
            errorLabel.text = "Invalid username or password!"
        }
    }

    Item {
        width: 300
        height: 400
        anchors.centerIn: parent

        Rectangle {
            anchors.centerIn: parent

            width: 280
            height: column.height + 40
            radius: 10

            ColumnLayout {
                id: column

                width: parent.width - 20

                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top


                Image {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.bottomMargin: 15
                    source: "images/logo.png"
                    height: 100
                }

                TextField {
                    id: usernameField
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    placeholderText: "username"

                    Keys.onReturnPressed: {
                        console.debug(Logger.log, "usernameField")
                        tryLogin()
                    }

                    Keys.onEnterPressed: {
                        console.debug(Logger.log, "usernameField")
                        tryLogin()
                    }
                }

                TextField {
                    id: passwordField

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    placeholderText: "password"
                    echoMode: TextInput.Password

                    Keys.onReturnPressed: {
                        console.debug(Logger.log, "passwordField")
                        tryLogin()
                    }

                    Keys.onEnterPressed: {
                        console.debug(Logger.log, "passwordField")
                        tryLogin()
                    }
                }

                Text {
                    id: errorLabel

                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width
                    Layout.preferredHeight: text != "" ? implicitHeight : 0

                    horizontalAlignment: Text.AlignHCenter

                    wrapMode: Text.Wrap
                    color: '#a00'
                    text: ""
                    font.pointSize: 10
                    opacity: text !== "" ? 1 : 0


                    Behavior on opacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuart
                        }
                    }

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuart
                        }
                    }
                }

                Button {
                    id: loginButton
                    objectName: "loginButton"

                    enabled: username.length !== 0
                             && password.length !== 0
                             && !loginInProgress

                    property string customColor: enabled ? "#09f" : "#999"

                    Layout.fillWidth: true
                    Layout.topMargin: (errorLabel.opacity-1.) * parent.spacing

                    // enabled:
                    text: "LOGIN"
                    onClicked: {
                        console.debug(Logger.log, "loginButton")
                        tryLogin()
                    }
                }
            }
        }
    }
}
