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

    address: getSettingVariable('host')
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
                    onClicked: { console.log("Export not yet implemented") }
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
                    onClicked: { console.log("Logout not yet implemented") }
                }
            }
        }

        RowLayout {
            Layout.fillHeight: true

            FilteringPane {

                Layout.preferredWidth: 300
                Layout.fillHeight: true

                onApplyClicked: {
                    currentFilter = filter
                    imageViewAndControls.imageView.clearData()
                    storeScrollLastPos()
                    pageLoader.resetPagesStatus()
                    pageLoader.loadNextPage(getCurrentFilter())
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

                    for(let i = 0; i < model.count; i++) {

                        const item = model.get(i)

                        if(!imageViewAndControls.filter(item) && item.selected) {

                            const current = makeCopy(item.metadata)
                            const update = Object.assign(makeCopy(item.metadata),
                                                         criteria)

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

