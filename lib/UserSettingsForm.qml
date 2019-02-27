import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root
    property ListModel userListModel: ListModel {}
    property string selectedUser: ''

    function getSelectedUsername() {
       if (userList.currentIndex != -1)
           return userListModel.get(userList.currentIndex)
       return {}
    }

    Dialog {
        id: responseDialog

        parent: ApplicationWindow.overlay

        x: Math.floor((parent.width - width) / 2)
        y: Math.floor((parent.height - height) / 2)

        standardButtons: Dialog.Ok

        Label {
          id: message
          text: qsTr('Server response text')
        }
    }

    Component {
        id: userListDelegate
        Item {
            width: parent.width
            height: 40
            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                leftPadding: 10
                text: '<b>' + username + '</b>'
            }
            MouseArea {
                anchors.fill: parent
                onClicked: userList.currentIndex = index
            }
        }
    }

    Text {
        Layout.fillWidth: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        text: '<b>USERS LIST</b>'
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        Layout.leftMargin: 10
        Layout.rightMargin: 10

        color: 'lightgray'
    }

    ListView {
        id: userList
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: root.userListModel
        delegate: userListDelegate
        currentIndex: -1

        highlight: Rectangle {
            color: 'whitesmoke'
        }
        onCurrentItemChanged: { console.log(root.getSelectedUsername().username + ' selected') }
    }

    RowLayout {
        Item {
            Layout.fillWidth: true
        }

        Button {
            Layout.preferredHeight: 30
            text: qsTr('Reload List')

            Material.primary: Material.Grey
            Material.background: Material.background

            onClicked: {
                message.text = "RELOAD!"
                responseDialog.open()
            }
        }

        Item {
            width: 20
        }

        Button {
            Layout.preferredHeight: 30
            text: qsTr('Add user')

            Material.primary: Material.Grey
            Material.background: Material.background

            onClicked: {
                console.log("ADD USER!")
                message.text = "ADD USER!"
                responseDialog.open()
            }
        }

        ToolButton {
            Layout.preferredHeight: 30
            text: qsTr('Remove user')

            Material.primary: Material.Grey
            Material.background: Material.background

            onClicked: {
                console.log("REMOVE USER!")
                message.text = "REMOVE USER!"
                responseDialog.open()
            }
        }
    }

  Dialog {
      id: confirmRemoveUser
  }

  Dialog {
      id: addUser
  }

  Component.onCompleted: {
      userListModel.append({username: "First User"})
      userListModel.append({username: "Second User"})
      userListModel.append({username: "Third User"})
  }
}
