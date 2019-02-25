import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

FocusScope {

    //signal login is emitted after a successful login
    signal login()

    property alias username: username.text
    property alias password: password.text

    function clean() {
        username.text = ''
        password.text = ''
    }

    Item {
        id: loginRequest
        property bool busy: false
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
                    id: username
                    placeholderText: "username"
                }

                TextField {
                    id: password
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

                    enabled: username.text.length !== 0
                             && password.text.length !== 0
                             && !loginRequest.busy

                    property string customColor: enabled ? "#09f" : "#999"

                    Layout.fillWidth: true
                    Layout.topMargin: (errorLabel.opacity-1.) * parent.spacing

                    // enabled:
                    text: "LOGIN"
                    onClicked: {
                        loginRequest.busy = true
                        login()
                    }
                }
            }
        }
    }
}
