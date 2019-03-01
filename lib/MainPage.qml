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
        lastContentYPos = imageViewAndControls.imageView.getContentY()
    }

    function restoreScrollLastPos(){
        imageViewAndControls.imageView.setContentY(lastContentYPos)
    }

    function getCurrentFilter() {
        if (currentFilter) {
            return JSON.parse(JSON.stringify(currentFilter))
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
            uploadButton.background.color = 'lightgreen'
            uploadInProgress = false
        }
        onError: {
            uploadButton.background.color = 'lightcoral'
            uploadInProgress = false
        }
        onUploadStarted: {
            uploadButton.background.color = 'lightgray'
            uploadInProgress = true
        }
    }

    ExportDialog {
        id: exportDialog
        onAccepted: exportItems.call(exportDialog.exportCriteria)
        onUserListRequested: listUsers.call()
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
                    onClicked: exportDialog.open()
                }

                DelayButton {
                    id: uploadButton
                    Layout.rightMargin: 5

                    text: 'Upload data'
                    delay: 0
                    progress: uploadDialog.uploadProgress

                    onClicked: {
                        if(!uploadInProgress) uploadButton.background.color = 'lightgray'
                        uploadDialog.open()
                    }
                }

                ToolButton {
                    text: qsTr("⋮")
                    Layout.rightMargin: 5
                    onClicked: { console.log("Settings not yet implemented") }
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

            FilteringPane {
                id: filteringPane

                Layout.preferredWidth: 300
                Layout.fillHeight: true

                onApplyClicked: {
                    currentFilter = filter
                    imageViewAndControls.imageView.clearData()
                    storeScrollLastPos()
                    pageLoader.resetPagesStatus()
                    pageLoader.loadNextPage(getCurrentFilter())
                }

                onUserListRequested: listUsers.call()

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
                    if(pageLoader.internal.pageLoadingInProgress || pageLoader.internal.lastPageLoaded) return
                    storeScrollLastPos()
                    pageLoader.loadNextPage(getCurrentFilter())
                }
            }

            AnnotationPane {
                id: annotationPane
                Layout.preferredWidth: 300
                Layout.fillHeight: true

                onApplyClicked: {
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
            currentSas = res.token
            if (!viewPopulated) {
                pageLoader.resetPagesStatus()
                pageLoader.loadNextPage({})
            }
        }

        onError: {
            console.log('sas failed. Details: ' + details)
        }
    }

    Timer {
        interval: 1000 * 60 * 30 // 30 min
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            sas.call('processed')
        }
    }

    Request {
        id: filterItems

        handler: dataAccess.filterItems

        onSuccess: {
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
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }

    Request {
        id: updateItems

        handler: dataAccess.updateItems

        onSuccess: {
            console.log("Update items")
            imageViewAndControls.imageView.clearData()
            pageLoader.loadPages(getCurrentFilter(), pageLoader.getNumberOfLoadedPages())
        }

        onError: {
            // TODO
            console.log("Updating annotations failed!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Request {
        id: exportItems
        handler: dataAccess.exportItems

        onSuccess: exportDialog.processExportResponse(true, res)
        onError: exportDialog.processExportResponse(false, details)
    }

    Request {
        id: listUsers
        handler: dataAccess.userList

        onSuccess: {
            let receivers = [filteringPane, exportDialog]
            let userList = res.map(item => item.username)
            for (const item of receivers) {
                item.userList = userList
            }
        }
    }
}

