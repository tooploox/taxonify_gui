import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ColumnLayout {
    id: root

    Layout.margins: 5

    property ListModel usersList: ListModel {}
    property string selectedUser: ''

    Dialog {
        id: responseDialog

        parent: ApplicationWindow.overlay

        x: Math.floor((parent.width - width) / 2)
        y: Math.floor((parent.height - height) / 2)

        standardButtons: Dialog.Ok

        Label {
          id: message
          text: "Server response text"
        }
    }
    Component {
        id: userListDelegate
        Item {
            width: 180; height: 40
            Column {
                Text { text: '<b>' + username + '</b>' }
            }
        }
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: root.usersList
        delegate: userListDelegate

        //onSelect: selectedUser == selection
    }

    RowLayout {
        Item {
            Layout.fillWidth: true
        }

        Button {
            Layout.preferredHeight: 30
            text: "Add user"
            onClicked: {
                console.log("ADD USER!")
                message.text = "ADD USER!"
                responseDialog.open()
            }
        }

        Button {
            Layout.preferredHeight: 30
            text: "Remove user"
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
      usersList.append({username: "First User"})
      usersList.append({username: "Second User"})
      usersList.append({username: "Third User"})
  }
}
