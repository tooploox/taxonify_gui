import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import com.microscopeit 1.0

Item {
    id: root

    readonly property alias uploadProgress : progress.value

    /**
      * Address on which put operation will be performed
      */
    property alias address: uploader.address

    /**
      * JWT token which will be send in Authorization header if not empty
      */
    property alias token: uploader.token

    /**
      * Signal emitted when file is choosen but upload is not started yet.
      * It may be used for example to set address containing filename in the
      * url.
      */
    signal fileSelected(url file)

    /**
      * Signal emitted when upload is successfully finished. 'replyData'
      * contains response body (not parsed).
      */
    signal success(string replyData)

    QtObject {
        id: internal

        property string fileName
        property string message
        property string errorMessage
        property int errorStatus
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home

        onAccepted: {
            let file = decodeURIComponent(fileDialog.fileUrl)
            file = uploader.getPlatformFilePath(file)
            fileSelected(file)

            internal.message = ''
            internal.errorMessage = ''
            internal.fileName = file

            uploader.upload(file)
        }
    }

    Uploader {
        id: uploader

        onSuccess: {
            internal.message = 'Upload finished successfully!'
            root.success(replyData)
        }
        onError: {
            internal.errorMessage = errorString
            internal.errorStatus = status
        }
        onProgressChanged: progress.value = bytesSent / bytesTotal
    }

    RowLayout {
        anchors.fill: parent

        Button {
            text: 'Select File'
            enabled: !internal.fileName || internal.message
                     || internal.errorMessage
            onClicked: fileDialog.visible = true
        }

        Button {
            text: 'Abort'
            enabled: internal.fileName && !internal.message
                     && !internal.errorMessage
            onClicked: uploader.abort()
        }

        ColumnLayout {
            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                elide: Text.ElideLeft

                text: {
                    if(internal.errorMessage) {
                        return 'Error occured: ' + internal.errorMessage + '. Error status: ' + internal.errorStatus;
                    } else if(internal.message) {
                        return internal.message
                    } else if(internal.fileName) {
                        return 'Uploading file: ' + internal.fileName
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

                Behavior on value {
                    NumberAnimation { duration: 500 }
                }
            }
        }
    }
}
