import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {
    visible: true

    width: 640 * 2
    height: 480 * 1.5

    title: qsTr("Aquascope Data Browser")

    readonly property var defaultSettings: ({
        host: 'http://localhost',
        username: 'aq_user',
        password : 'hardpass'
    })

    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    property var currentFilter: {}
    property string currentSas: ''
    property bool viewPopulated: false
    property real scrollViewLastPos: 0

    function storeScrollLastPos(){
        scrollViewLastPos = imageViewAndControls.imageView.getCurrentScrollPosition()
    }

    function restoreScrollLastPos(){
        imageViewAndControls.imageView.setScrollPosition(scrollViewLastPos)
    }

    function getSettingVariable(key) {
        if(settingsFromFile) {
            if (settingsFromFile && settingsFromFile[key]) {
                return settingsFromFile[key]
            } else {
                console.log('No"' + key + '" field found in settings.')
            }
        } else {
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultSettings[key]) {
            return defaultSettings[key]
        } else {
            console.log('key ' + key
                        + ' not found in dafaults array. Returning null')
            return null
        }
    }

    function getCurrentFilter() {
        if (currentFilter) {
            return JSON.parse(JSON.stringify(currentFilter))
        }
        return {}
    }

    Item{
       id: pageLoader

       property var pagesLoaded: 0
       property bool pageLoadingInProgress: false
       property bool lastPageLoaded: false
       property var multiplePagesToLoad: []
       property bool multiplePagesLoading: false

       function nextPageNumber() { return pagesLoaded + 1; }

       function resetPagesStatus() {
           pagesLoaded = 0
           lastPageLoaded = false
       }

       function loadNextPage(filter){
           let pageNo = nextPageNumber()
           console.log("load Next page: " + pageNo)
           loadPage(filter, pageNo)
       }

       function loadPage(filter, pageNumber){
         pageLoadingInProgress = true
         filterPagedItems.call(filter, pageNumber)
       }

       function loadPages(filter, pagesToLoad){
           resetPagesStatus()
           multiplePagesLoading = true

           var pagesRange = [...Array((pagesToLoad+1)).keys()]  // Generate range 0 ... n
           multiplePagesToLoad = pagesRange.slice(1)
           console.log(multiplePagesToLoad)
           var pageToLoad = multiplePagesToLoad[0]
           multiplePagesToLoad.shift()
           loadPage(filter, pageToLoad)
       }

       function finishLoadingPage(continuationToken){
           console.log("Finished loading page " + nextPageNumber())

           let loadedPage = pagesLoaded
           pagesLoaded += 1
           lastPageLoaded = (continuationToken === undefined ? true : false)
           pageLoadingInProgress = false
           if(lastPageLoaded) multiplePagesToLoad = []

           if(multiplePagesLoading){
               if(multiplePagesToLoad.length > 0){
                 var pageToLoad = multiplePagesToLoad[0]
                 multiplePagesToLoad.shift()
                 loadPage(getCurrentFilter(), pageToLoad)
               }
               else {
                   multiplePagesToLoad = false
                   restoreScrollLastPos()
               }
           }
       }
    }

    RowLayout {
        anchors.fill: parent

        FilteringPane {

            Layout.preferredWidth: 300
            Layout.fillHeight: true

            onAppliedClicked: {
                currentFilter = filter
                imageViewAndControls.imageView.clearData()
                pageLoader.resetPages()
                pageLoader.loadNextPage(getCurrentFilter())
            }

        }

        ImageViewAndControls {
            id: imageViewAndControls

            address: getSettingVariable('host')
            token: dataAccess.internal.access_token

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
                if(pageLoader.pageLoadingInProgress || pageLoader.lastPageLoaded) return
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

    property var dataAccess: DataAccess {}

    Request {
        id: login

        handler: dataAccess.login

        onSuccess: sas.call('processed')
        onError: console.log('Login failed. Details: ' + details)
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
        id: filterPagedItems

        handler: dataAccess.filterPagedItems

        onSuccess: {
            const params = currentSas.length > 0 ? '?' + currentSas : ''

            function makeItem(item) {
                return {
                    image: res.urls[item._id], //+ params,
                    selected: false,
                    metadata: item
                }
            }

            let data = res.items.map(makeItem)

            if(data.length > 0){
                viewPopulated = true
                imageViewAndControls.imageView.appendData(data, true)
            }

            pageLoader.finishLoadingPage(res.continuation_token)
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
            pageLoader.loadPages(getCurrentFilter(), pageLoader.pagesLoaded)
        }

        onError: {
            // TODO
            console.log("Updating annotations failed!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Component.onCompleted: {
        const serverAddress = getSettingVariable('host')
        dataAccess.server = new Req.Server(serverAddress)
        const username = getSettingVariable('username')
        const password = getSettingVariable('password')
        login.call(username, password)
    }
}

