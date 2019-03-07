import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    readonly property ListModel uploadData: ListModel {}

    function setData(data){
       console.log(Logger.debug, "UploadList: setData()")
       uploadData.clear()
       for(let d of data){
           let genDate = d.generation_date.split('T')
           uploadData.append({filename: d.filename,
                              up_state: d.state,
                              gen_date: genDate[0] + "   " +genDate[1].split('+')[0]})
       }
    }

    ListView {
        id: filesList
        anchors.fill: parent
        model: uploadData

        ScrollBar.vertical: ScrollBar {}

        Layout.alignment: Qt.AlignCenter

        delegate: Item {
            width: parent.width - 20
            height: 60

            Column {
                id: content

                anchors.fill: parent
                anchors.topMargin: 5
                anchors.bottomMargin: 5

                RowLayout {
                    Layout.fillWidth: true
                    width: parent.width

                    Text {
                        id: mainLine
                        text: '<b>' + filename + '</b>'
                    }

                    Text {
                        Layout.alignment: Qt.AlignRight
                        text: up_state
                    }
                }

                Text {
                    font.pointSize: mainLine.font.pointSize - 2
                    text: "    Date:   " + gen_date
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
