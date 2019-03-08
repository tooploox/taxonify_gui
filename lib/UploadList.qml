import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    readonly property ListModel uploadData: ListModel {}
    signal uploadDetailsRequested(string upload_id)

    function setData(data){
       uploadData.clear()
       for(let d of data){
           let genDate = d.generation_date.split('T')
           uploadData.append({
                              _id: d._id,
                              filename: d.filename,
                              up_state: d.state,
                              gen_date: genDate[0] + " " +genDate[1].split('+')[0],
                              image_count: d.image_count === undefined ? '-' : d.image_count.toString(),
                              duplicate_image_count: d.duplicate_image_count === undefined ? '-' : d.duplicate_image_count.toString()
                             })
       }
    }

    ListView {
        id: filesList
        anchors.fill: parent
        model: uploadData
        clip: true

        ScrollBar.vertical: ScrollBar { id: scroll }

        delegate: ColumnLayout {
            id: content
            width: filesList.width - scroll.width
            anchors.margins: 5

            RowLayout {
                Layout.fillWidth: true
                Text {
                    id: mainLine
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    text: filename
                    font.bold: true
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                    Layout.rightMargin: 5
                    text: up_state
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 20

                Text {
                    font.pointSize: mainLine.font.pointSize - 2
                    text: "Date:   " + gen_date
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        font.pointSize: mainLine.font.pointSize - 2
                        text: "Duplicate images:   " + duplicate_image_count + '/' + image_count
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ToolButton {
                        id: moreButton
                        Layout.rightMargin: 5
                        text: '...'
                        onClicked: {
                            console.log('buttonclicked')
                            uploadDetailsRequested(_id)
                        }
                    }
                }
            }

            MenuSeparator {
                Layout.fillWidth: true
            }
       }
    }
}
