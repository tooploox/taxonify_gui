import QtQuick 2.12

import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
// This import needs to be in this order to use QtQuick.Control Dialog class for duplicated Dialog!
import QtQuick.Controls 2.12

import com.microscopeit 1.0

import "qrc:/network"

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

    signal error(string errorMsg)

    signal uploadStarted()

    QtObject {
        id: internal

        property string fileName
        property string message
        property string errorMessage
        property int errorStatus
    }

    function proceedWithUpload(uploadedPackages) {
        console.info(Logger.log, "")
        let baseName = uploader.getFileName(internal.fileName)
        for(let pack of uploadedPackages) {
            if(baseName == pack.filename) {
                return duplicated.open()
            }
        }
        startUpload()
    }

    function startUpload() {
        console.info(Logger.log, "")
        root.uploadStarted()
        uploader.upload(internal.fileName)
    }

    function clearUploadStatus() {
        console.info(Logger.log, "")
        internal.errorMessage = ''
        internal.errorStatus = 0
        internal.fileName = ''
        uploadMessage.text = 'Select file for upload'
    }

    Request{
        id: checkPackagename
        handler: dataAccess.uploadList

        onSuccess: {
            console.info(Logger.log, "checkPackagename")
            root.proceedWithUpload(res)
        }

        onError: {
            console.info(Logger.log, "checkPackagename")
            console.log("Failed to get upload list! Details: " + details)
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        nameFilters: ["Data packages tar.bz2 (*.tar.bz2)", "All files (*)"]

        onAccepted: {
            console.info(Logger.log, "fileDialog")
            let file = decodeURIComponent(fileDialog.fileUrl)
            file = uploader.getPlatformFilePath(file)
            fileSelected(file)

            internal.message = ''
            internal.errorMessage = ''
            internal.fileName = file

            checkPackagename.call()
        }
    }

    Dialog {
        id: duplicated

        modal: true
        parent: ApplicationWindow.overlay

        width: 450
        height: 150

        x: Math.floor((parent.width - width) / 2)
        y: Math.floor((parent.height - height) / 2)

        title: qsTr("Package " + uploader.getFileName(internal.fileName) + " is already uploaded")
        standardButtons: Dialog.Yes | Dialog.No

        onAccepted: {
            console.info(Logger.log, "duplicated Dialog")
            root.startUpload()
        }

        onRejected: {
            console.info(Logger.log, "duplicated Dialog")
            clearUploadStatus()
        }

        Label {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Do you want to upload <b>" + uploader.getFileName(internal.fileName) + "</b> for the second time?"
        }
    }

    Uploader {
        id: uploader

        onSuccess: {
            console.info(Logger.log, "uploader")
            internal.message = 'Upload finished successfully!'
            root.success(replyData)
        }

        onError: {
            console.info(Logger.log, "uploader")
            internal.errorMessage = errorString
            internal.errorStatus = status
            root.error(internal.errorMessage)
        }

        onProgressChanged: progress.value = bytesSent / bytesTotal
    }

    RowLayout {
        anchors.fill: parent

        Button {
            text: 'Select File'
            enabled: !internal.fileName || internal.message
                     || internal.errorMessage

            onClicked: {
                console.debug(Logger.log, "Select file button")
                fileDialog.visible = true
            }
        }

        Button {
            text: 'Abort'
            enabled: internal.fileName && !internal.message
                     && !internal.errorMessage

            onClicked: {
                console.debug(Logger.log, "Abort button")
                uploader.abort()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true

            Label {
                id: uploadMessage
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
