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

    property bool loginInProgress: false

    function clean() {
        username = ''
        password = ''
        errorMsg = ''
        loginInProgress = false
    }

    function tryLogin() {
        if(username.length == 0 || password.length == 0) return
        loginInProgress = true
        console.log(username + "p: " + password)
        loginRequest.call(username, password)
    }

    Request {
        id: loginRequest
        handler: dataAccess.login

        onSuccess: {
            loginInProgress = false
            root.userLogged(username)
        }

        onError: {
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
                    source: "images/logo.png"
                    height: 100
                }

                TextField {
                    id: usernameField
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    placeholderText: "username"

                    Keys.onReturnPressed: tryLogin()
                    Keys.onEnterPressed: tryLogin()
                }

                TextField {
                    id: passwordField

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    placeholderText: "password"
                    echoMode: TextInput.Password

                    Keys.onReturnPressed: tryLogin()
                    Keys.onEnterPressed: tryLogin()
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
                    onClicked: tryLogin()
                }
            }
        }
    }

    Component.onCompleted: {
        usernameField.forceActiveFocus()
    }
}
