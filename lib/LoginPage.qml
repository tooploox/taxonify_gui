import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import 'qrc:/network'

FocusScope {
    id: root

    //signal userLogged is emitted after a successful login
    signal userLogged(string username)

    property alias username: usernameField.text
    property alias password: passwordField.text

    function clean() {
        username = ''
        password = ''
    }

    Request {
        id: loginRequest
        handler: dataAccess.login

        onSuccess: {
            root.userLogged(username)
        }

        onError: {
            errorLabel.text = "Invalid username or password!"
        }
    }

    Item {
        width: 300
        height: 400
        anchors.centerIn: parent

        Rectangle {
            anchors.centerIn: parent

            width: 200
            height: column.height + 40
            radius: 10

            ColumnLayout {

                id: column

                anchors.margins: 20
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                TextField {
                    id: usernameField
                    Layout.alignment: Qt.AlignHCenter
                    placeholderText: "username"
                }

                TextField {
                    id: passwordField
                    Layout.alignment: Qt.AlignHCenter
                    placeholderText: "password"
                    echoMode: TextInput.Password
                }

                Text {
                    id: errorLabel

                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.width
                    Layout.preferredHeight: text != "" ? implicitHeight : 0

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

                    property string customColor: enabled ? "#09f" : "#999"

                    Layout.fillWidth: true
                    Layout.topMargin: (errorLabel.opacity-1.) * parent.spacing

                    // enabled:
                    text: "LOGIN"
                    onClicked: {
                        loginRequest.call(username, password)
                    }
                }
            }
        }
    }
}
