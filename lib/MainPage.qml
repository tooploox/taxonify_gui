import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/network"
import "qrc:/network/requests.js" as Req

Item {
    id: root

    property string currentSas: ''
    property var currentFilter: {}
    property bool viewPopulated: false
    property real lastContentYPos: 0
    signal logoutClicked()

    function storeScrollLastPos() {
        console.debug(Logger.log, "")
        lastContentYPos = imageViewAndControls.imageView.getContentY()
    }

    function restoreScrollLastPos() {
        console.debug(Logger.log, "")
        imageViewAndControls.imageView.setContentY(lastContentYPos)
    }

    function getCurrentFilter() {
        console.debug(Logger.log, "")
        if (currentFilter) {
             console.debug(Logger.log, "filter not empty")
            return JSON.parse(JSON.stringify(currentFilter))
        } else {
            console.debug(Logger.log, "filter empty")
        }

        return {}
    }

    property alias address : uploadDialog.address
    property alias token : uploadDialog.token
    property bool uploadInProgress: false
    property string currentUser

    token: dataAccess.internal.access_token

    UploadDialog {
        id: uploadDialog
        onSuccess: {
            console.debug(Logger.log, "UploadDialog")
            uploadButton.background.color = 'lightgreen'
            uploadInProgress = false
        }
        onError: {
            console.debug(Logger.log, "UploadDialog")
            uploadButton.background.color = 'lightcoral'
            uploadInProgress = false
        }
        onUploadStarted: {
            console.debug(Logger.log, "UploadDialog")
            uploadButton.background.color = 'lightgray'
            uploadInProgress = true
        }
        onUploadDetailsRequested: getUpload.call(upload_id)
        onTagsUpdateRequested: postTags.call(upload_id, tags)
    }

    ExportDialog {
        id: exportDialog
        onAccepted: exportItems.call(exportDialog.exportCriteria)
        onUserListRequested: {
            console.debug(Logger.log, "ExportDialog")
            listUsers.call()
        }
    }

    PageLoader {
        id: pageLoader

        appendDataToModel: imageViewAndControls.imageView.appendData
        restoreModelViewLastPos: restoreScrollLastPos

        currentSas: root.currentSas
    }

    SettingsDialog {
        id: settingsDialog

        onUserListRequested: listUsers.call()
        onAddUserRequested: addUserRequest.call(username)
    }

    ColumnLayout {

        anchors.fill: parent

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            border.color: 'lightgray'

            RowLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                }

                Label {
                    text: qsTr("You are signed in as: ")
                }

                Label {
                    text: currentUser
                    font.bold: true
                    rightPadding: 10
                }

                ToolButton {
                    text: qsTr("Export")
                    Layout.rightMargin: 5
                    onClicked: {
                        console.debug(Logger.log, "Export")
                        exportDialog.open()
                    }
                }

                DelayButton {
                    id: uploadButton
                    Layout.rightMargin: 5

                    text: 'Upload data'
                    delay: 0
                    progress: uploadDialog.uploadProgress

                    onClicked: {
                        console.debug(Logger.log, "uploadButton")
                        if(!uploadInProgress) uploadButton.background.color = 'lightgray'
                        uploadDialog.open()
                    }
                }

                ToolButton {
                    text: qsTr("⋮")
                    Layout.rightMargin: 5

                    onClicked: {
                        console.debug(Logger.log, "ToolButton")
                        settingsDialog.open()
                    }
                }

                ToolButton {
                    text: qsTr("Log out")
                    Layout.rightMargin: 15
                    onClicked: {
                        logoutClicked()
                        dataAccess.internal.access_token = ''
                    }
                }
            }
        }

        RowLayout {
            Layout.fillHeight: true

            ColumnLayout {
                Layout.preferredWidth: 300
                Layout.maximumWidth: 300

                TabBar {
                    id: leftBar
                    Layout.fillWidth: true

                    TabButton {
                        text: qsTr("Filtering")
                    }
                    TabButton {
                        text: qsTr("Image details")
                    }
                }

                StackLayout {
                    currentIndex: leftBar.currentIndex
                    Layout.fillWidth: true

                    FilteringPane {
                        id: filteringPane
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        withTitle: false

                        onApplyClicked: {
                            console.debug(Logger.log, "FilteringPane")
                            currentFilter = filter
                            imageViewAndControls.imageView.clearData()
                            storeScrollLastPos()
                            pageLoader.resetPagesStatus()
                            pageLoader.loadNextPage(getCurrentFilter())
                        }

                        onUserListRequested: {
                            console.debug(Logger.log, "FilteringPane")
                            listUsers.call()
                        }
                    }

                    ImageDetailsPane {
                        id: imageDetailsPane
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                }
            }

            ImageViewAndControls {
                id: imageViewAndControls

                Layout.fillWidth: true
                Layout.fillHeight: true

                pageLoadingInProgress: pageLoader.internal.pageLoadingInProgress

                filter: ((criteria) => {
                             return (item) => {
                                 for (let c in criteria) {
                                     if (item.metadata[c] !== criteria[c])
                                     return false
                                 }
                                 return true
                             }

                         })(annotationPane.criteria)

                onAtPageBottom: {
                    console.debug(Logger.log, "imageViewAndControls")
                    if(pageLoader.internal.pageLoadingInProgress || pageLoader.internal.lastPageLoaded) {
                        console.debug(Logger.log, "imageViewAndControls - pageLoadingInProgress or lastPageLoaded")
                        return
                    }
                    console.debug(Logger.log, "imageViewAndControls - next page to be loaded")

                    storeScrollLastPos()
                    pageLoader.loadNextPage(getCurrentFilter())
                }

                onItemHovered: {
                    imageDetailsPane.displayHoveredItem(hoveredItem)
                }
                onItemRightClicked: {
                    imageDetailsPane.displayRightClickedItem(rightClickedItem)
                }
            }

            ColumnLayout {
                Layout.preferredWidth: 300
                Layout.maximumWidth: 300

                TabBar {
                    id: rightBar
                    Layout.fillWidth: true

                    TabButton {
                        text: qsTr("Annotation")
                    }
                }

                StackLayout {
                    currentIndex: rightBar.currentIndex
                    Layout.fillWidth: true

                    AnnotationPane {
                        id: annotationPane
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        onApplyClicked: {
                            console.debug(Logger.log, "AnnotationPane")
                            storeScrollLastPos()

                            const model = imageViewAndControls.imageView.model

                            const toUpdate = []

                            function makeCopy(obj) {
                                return JSON.parse(JSON.stringify(obj))
                            }

                            let now = new Date().toISOString()

                            for(let i = 0; i < model.count; i++) {

                                const item = model.get(i)

                                if(!imageViewAndControls.filter(item) && item.selected) {

                                    let annotation_update = makeCopy(criteria)
                                    for (let field in criteria) {
                                        annotation_update[field + '_modification_time'] = now
                                        annotation_update[field + '_modified_by'] = currentUser
                                    }

                                    const current = makeCopy(item.metadata)
                                    const update = Object.assign(makeCopy(item.metadata),
                                                                 annotation_update)

                                    const updateItem = {
                                        current: current,
                                        update: update
                                    }

                                    toUpdate.push(updateItem)
                                }

                                // remove selection
                                item.selected = false
                            }
                            if (toUpdate.length > 0) {
                                updateItems.call(toUpdate)
                            }
                        }
                    }
                }
            }
        }
    }

    Request {
        id: sas

        handler: dataAccess.sas

        onSuccess: {
            console.debug(Logger.log, "sas")
            currentSas = res.token
            if (!viewPopulated) {
                console.debug(Logger.log, "sas - not viewPopulated")
                pageLoader.resetPagesStatus()
                pageLoader.loadNextPage({})
            } else {
                console.debug(Logger.log, "sas - viewPopulated")
            }
        }

        onError: {
            console.debug(Logger.log, "sas")
            console.log('sas failed. Details: ' + details)
        }
    }

    Timer {
        interval: 1000 * 60 * 30 // 30 min
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            console.debug(Logger.log, "Timer")
            sas.call('processed')
        }
    }

    Request {
        id: filterItems

        handler: dataAccess.filterItems

        onSuccess: {
            console.debug(Logger.log, "filterItems")
            const params = currentSas.length > 0 ? '?' + currentSas : ''

            function makeItem(item) {
                return {
                    image: res.urls[item._id] + params,
                    selected: false,
                    metadata: item
                }
            }

            let data = res.items.map(makeItem)

            viewPopulated = true
            imageViewAndControls.imageView.setData(data)
        }

        onError: {
            console.debug(Logger.log, "filterItems")
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }

    Request {
        id: updateItems

        handler: dataAccess.updateItems

        onSuccess: {
            console.debug(Logger.log, "updateItems")
            console.log("Update items")
            imageViewAndControls.imageView.clearData()
            pageLoader.loadPages(getCurrentFilter(), pageLoader.getNumberOfLoadedPages())
        }

        onError: {
            console.debug(Logger.log, "updateItems")
            // TODO
            console.log("Updating annotations failed!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Request {
        id: exportItems
        handler: dataAccess.exportItems

        onSuccess: {
            console.debug(Logger.log, "exportItems")
            exportDialog.processExportResponse(true, res)
        }

        onError: {
            console.debug(Logger.log, "exportItems")
            exportDialog.processExportResponse(false, details)
        }
    }

    Request {
        id: listUsers
        handler: dataAccess.userList

        onSuccess: {
            console.debug(Logger.log, "listUsers")
            let receivers = [filteringPane, exportDialog, settingsDialog]
            let userList = res.map(item => item.username)
            for (const item of receivers) {
                item.updateUserList(userList)
            }
        }
    }

    Request {
        id: addUserRequest
        handler: dataAccess.addUser

        onSuccess: settingsDialog.addUserResponse(true)
        onError: settingsDialog.addUserResponse(false)
    }

    Request {
        id: getUpload
        handler: dataAccess.getUpload

        onSuccess: uploadDialog.showUploadDetails(res)
    }

    Request {
        id: postTags
        handler: dataAccess.postTags
    }
}

