import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import com.microscopeit 1.0

import "qrc:/network"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    Request {

    }

    property string fileName
    property string messageStr
    property string errorStr

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        onAccepted: {

            let file = decodeURIComponent(fileDialog.fileUrl)

            if(Qt.platform.os === 'windows')
                file = file.substring(8)
            else
                file = file.substring(7)

            messageStr = ''
            errorStr = ''
            fileName = file

            uploader.upload(file)
        }
    }

    Uploader {
        id: uploader

        address: 'https://httpbin.org/put'

        onSuccess: messageStr = 'Upload finished successfully!'
        onError: errorStr = errorString
        onProgressChanged: progress.value = bytesSent / bytesTotal
    }

    RowLayout {
        anchors.fill: parent

        Button {
            text: 'Select File'
            onClicked: fileDialog.visible = true
        }

        Button {
            text: 'Abort'
            enabled: fileName && !messageStr && !errorStr
            onClicked: uploader.abort()
        }

        ColumnLayout {
            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                elide: Text.ElideLeft
                text: {
                    if(errorStr) {
                        return 'Error occured: ' + errorStr;
                    } else if(messageStr) {
                        return messageStr
                    } else if(fileName) {
                        return 'Uploading file: ' + fileName
                    } else {
                        return 'Select file for upload'
                    }
                }

                horizontalAlignment: Text.AlignHCenter

                ToolTip.delay: 1000
                ToolTip.visible: truncated && mouse.containsMouse
                ToolTip.text: text

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                }

            }

            ProgressBar {
                id: progress
                Layout.fillWidth: true
            }
        }
    }
}
