import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root

    property string address;
    property alias token : uploadForm.token

    readonly property ListModel uploadData: ListModel {}

    function setData(data){
       uploadData.clear()
       for(let d of data){
           uploadData.append({filename: d['filename'],
                              up_state: d['state'],
                              gen_date: d['generation_date']})
       }
    }

    readonly property alias uploadProgress : uploadForm.uploadProgress

    signal success(string replyData)
    signal error(string errorMsg)
    signal uploadStarted()

    x: Math.floor((parent.width - width) / 2)
    y: Math.floor((parent.height - height) / 2)

    width: 600
    height: 300

    modal: true
    title: 'Upload data'
    standardButtons: Dialog.Close | Dialog.Reset

    parent: ApplicationWindow.overlay

    onAboutToShow: {
        let butt = standardButton(Dialog.Reset)
        butt.text = "List"
    }

    onReset: {
        uploadListDiag.open()
    }

    contentItem: UploadForm{
        id: uploadForm
        address: root.address + '/upload'
        token: dataAccess.internal.access_token
        onSuccess: root.success(replyData)
        onError: root.error(errorMsg)
        onUploadStarted: root.uploadStarted()
    }

    Dialog {
        id: uploadListDiag

        width: root.width
        height: root.height

        x: root.x
        y: root.y

        modal: true
        title: 'Uploaded files: ' + uploadList.count
        standardButtons: Dialog.Close

        parent: ApplicationWindow.overlay

        onAboutToShow: {
            dataAccess.uploadList(function(resp) {
                root.setData(resp.body)
            })
        }

        ListView {
            id: uploadList
            anchors.fill: parent
            model: root.uploadData

            Layout.alignment: Qt.AlignCenter

            delegate: Item{
                width: uploadList.width - 5
                height: 40
                Rectangle{
                    anchors.fill: parent
                    anchors.topMargin: 1
                    anchors.bottomMargin: 1
                    id: content
                    Text {
                        text: '<b>' + filename + ': </b>' + up_state + " | Date: " + gen_date
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    height: 1
                    color: 'darkgray'
                    anchors {
                        left: content.left
                        right: content.right
                        top: content.bottom
                    }
                }
           }
        }
    }
}
