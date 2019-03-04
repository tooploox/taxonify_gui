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
        Logger.log("MainPage: storeScrollLastPos()")
        lastContentYPos = imageViewAndControls.imageView.getContentY()
    }

    function restoreScrollLastPos() {
        Logger.log("MainPage: restoreScrollLastPos()")
        imageViewAndControls.imageView.setContentY(lastContentYPos)
    }

    function getCurrentFilter() {
        Logger.log("MainPage: getCurrentFilter()")
        if (currentFilter) {
             Logger.log("MainPage: getCurrentFilter - filter not empty")
            return JSON.parse(JSON.stringify(currentFilter))
        } else {
            Logger.log("MainPage: getCurrentFilter - filter empty")
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
            Logger.log("MainPage: UploadDialog - Success")
            uploadButton.background.color = 'lightgreen'
            uploadInProgress = false
        }
        onError: {
            Logger.log("MainPage: UploadDialog - Error")
            uploadButton.background.color = 'lightcoral'
            uploadInProgress = false
        }
        onUploadStarted: {
            Logger.log("MainPage: UploadDialog - UploadStarted")
            uploadButton.background.color = 'lightgray'
            uploadInProgress = true
        }
    }

    ExportDialog {
        id: exportDialog
        onAccepted: exportItems.call(exportDialog.exportCriteria)
        onUserListRequested: {
            Logger.log("MainPage: ExportDialog - UserListRequested")
            listUsers.call()
        }
    }

    PageLoader {
        id: pageLoader

        appendDataToModel: imageViewAndControls.imageView.appendData
        restoreModelViewLastPos: restoreScrollLastPos

        currentSas: root.currentSas
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
                        Logger.log("MainPage: Export clicked")
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
                        Logger.log("MainPage: DelayButton clicked")
                        if(!uploadInProgress) uploadButton.background.color = 'lightgray'
                        uploadDialog.open()
                    }
                }

                ToolButton {
                    text: qsTr("⋮")
                    Layout.rightMargin: 5
                    onClicked: {
                        Logger.log("MainPage: ToolButton clicked")
                        console.log("Settings not yet implemented")
                    }
                }

                ToolButton {
                    text: qsTr("Log out")
                    Layout.rightMargin: 15
                    onClicked: {
                        Logger.log("MainPage: Log out button clicked")
                        logoutClicked()
                        dataAccess.internal.access_token = ''
                    }
                }
            }
        }

        RowLayout {
            Layout.fillHeight: true

            FilteringPane {
                id: filteringPane

                Layout.preferredWidth: 300
                Layout.fillHeight: true

                onApplyClicked: {
                    Logger.log("MainPage: FilteringPane - ApplyClicked")
                    currentFilter = filter
                    imageViewAndControls.imageView.clearData()
                    storeScrollLastPos()
                    pageLoader.resetPagesStatus()
                    pageLoader.loadNextPage(getCurrentFilter())
                }

                onUserListRequested: {
                    Logger.log("MainPage: FilteringPane - UserListRequested")
                    listUsers.call()
                }

            }

            ImageViewAndControls {
                id: imageViewAndControls

                Layout.fillWidth: true
                Layout.fillHeight: true

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
                    Logger.log("MainPage: imageViewAndControls - AtPageBottom")
                    if(pageLoader.internal.pageLoadingInProgress || pageLoader.internal.lastPageLoaded) {
                        Logger.log("MainPage: imageViewAndControls - AtPageBottom - pageLoadingInProgress or lastPageLoaded")
                        return
                    }
                    Logger.log("MainPage: imageViewAndControls - AtPageBottom - next page to be loaded")

                    storeScrollLastPos()
                    pageLoader.loadNextPage(getCurrentFilter())
                }
            }

            AnnotationPane {
                id: annotationPane
                Layout.preferredWidth: 300
                Layout.fillHeight: true

                onApplyClicked: {
                    Logger.log("MainPage: AnnotationPane - ApplyClicked")
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

    Request {
        id: sas

        handler: dataAccess.sas

        onSuccess: {
            Logger.log("MainPage: sas succeeded")
            currentSas = res.token
            if (!viewPopulated) {
                Logger.log("MainPage: sas succeeded - not viewPopulated")
                pageLoader.resetPagesStatus()
                pageLoader.loadNextPage({})
            } else {
                Logger.log("MainPage: sas succeeded - viewPopulated")
            }
        }

        onError: {
            Logger.log("MainPage: sas failed")
            console.log('sas failed. Details: ' + details)
        }
    }

    Timer {
        interval: 1000 * 60 * 30 // 30 min
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            Logger.log("MainPage: Timer triggered")
            sas.call('processed')
        }
    }

    Request {
        id: filterItems

        handler: dataAccess.filterItems

        onSuccess: {
            Logger.log("MainPage: filterItems succeeded")
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
            Logger.log("MainPage: filterItems failed")
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }

    Request {
        id: updateItems

        handler: dataAccess.updateItems

        onSuccess: {
            Logger.log("MainPage: updateItems succeeded")
            console.log("Update items")
            imageViewAndControls.imageView.clearData()
            pageLoader.loadPages(getCurrentFilter(), pageLoader.getNumberOfLoadedPages())
        }

        onError: {
            Logger.log("MainPage: updateItems failed")
            // TODO
            console.log("Updating annotations failed!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Request {
        id: exportItems
        handler: dataAccess.exportItems

        onSuccess: {
            Logger.log("MainPage: exportItems succeeded")
            exportDialog.processExportResponse(true, res)
        }

        onError: {
            Logger.log("MainPage: exportItems failed")
            exportDialog.processExportResponse(false, details)
        }
    }

    Request {
        id: listUsers
        handler: dataAccess.userList

        onSuccess: {
            Logger.log("MainPage: listUsers succeeded")
            let receivers = [filteringPane, exportDialog]
            let userList = res.map(item => item.username)
            for (const item of receivers) {
                item.userList = userList
            }
        }
    }
}

