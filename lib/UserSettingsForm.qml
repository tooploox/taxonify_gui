import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
  id: root

  property ListModel usersList
  property string selectedUser: ''

  Column {
    ListView {
        delegate: usersList
        //onSelect: selectedUser == selection
    }

    Row {
        Button {
            text: "Add user"
            onClicked: {
                console.log("ADD USER!")
                responseDialog.message.text = "ADD USER!"
                responseDialog.open()
            }
        }

        Button {
            text: "Remove user"
            onClicked: {
                responseDialog.message.text = "REMOVE USER!"
                console.log("REMOVE USER!")
            }
        }
    }
  }

  Dialog {
      id: confirmRemoveUser
  }

  Dialog {
      id: addUser
  }

  Dialog {
      id: responseDialog
      standardButtons: Dialog.Ok
      Label {
        id: message
        text: "Server response text"
      }
  }
}
