import QtQuick 2.12

import "qrc:/network"

QtObject {
    property QtObject internal: QtObject {
        property int pagesLoaded: 0
        property bool pageLoadingInProgress: false
        property bool lastPageLoaded: false
        property var multiplePagesToLoad: []
        property var multipageData: []
        property bool multiplePagesLoading: false
    }

    // These properties needs to be set from the outside to manipulate external components

    // Function which appends received data to viewing model.
    // Signature: appendDataToModel([Array] data , [bool] useLastContentY )
    property var appendDataToModel

    // Function which restore last position of viewing model
    // Signature: restoreModelViewLastPos()
    property var restoreModelViewLastPos

    // Request type object for getting paged items with defined filter
    property string currentSas: ''

    // Public methods
    function getNumberOfLoadedPages() {
        console.debug(Logger.log, "")
        return internal.pagesLoaded
    }

    function nextPageNumber() {
        console.debug(Logger.log, "")
        return internal.pagesLoaded + 1
    }

    function resetPagesStatus() {
        console.debug(Logger.log, "")
        internal.pagesLoaded = 0
        internal.lastPageLoaded = false
    }

    function loadNextPage(filter){
        console.debug(Logger.log, "filter='" + JSON.stringify(filter) + "'")
        let pageNo = nextPageNumber()
        console.log("Load Next page: " + pageNo)
        loadPage(filter, pageNo)
    }

    function loadPage(filter, pageNumber){
        console.debug(Logger.log, "filter='" + JSON.stringify(filter) + "', pageNumber=" + pageNumber)
        internal.pageLoadingInProgress = true
        filterPagedItems.call(filter, pageNumber)
    }

    function loadPages(filter, pagesToLoad){
        console.debug(Logger.log, "filter='" + JSON.stringify(filter) + "', pagesToLoad=" + JSON.stringify(pagesToLoad))
        resetPagesStatus()
        internal.multiplePagesLoading = true

        const pagesRange = [...Array((pagesToLoad+1)).keys()]  // Generate range 0 ... n
        internal.multiplePagesToLoad = pagesRange.slice(1)
        let pageToLoad = internal.multiplePagesToLoad[0]
        internal.multiplePagesToLoad.shift()
        loadPage(filter, pageToLoad)
    }

    function finishLoadingPage(data, continuationToken){
        console.debug(Logger.log, "continuationToken='" + JSON.stringify(continuationToken) + "'")
        console.log("Finished loading page " + nextPageNumber())

        let loadedPage = internal.pagesLoaded
        internal.pagesLoaded += 1
        internal.lastPageLoaded = (continuationToken === undefined ? true : false)
        internal.pageLoadingInProgress = false
        if(internal.lastPageLoaded) {
            console.debug(Logger.log, "lastPageLoaded")
            internal.multiplePagesToLoad = []
        }

        if(internal.multiplePagesLoading) {
            console.debug(Logger.log, "multiplePagesLoading")
            if(data.length > 0) {
                console.debug(Logger.log, "data is not empty")
                internal.multipageData = internal.multipageData.concat(data)
            } else {
                console.debug(Logger.log, "data is empty")
            }

            if(internal.multiplePagesToLoad.length > 0) {
                console.debug(Logger.log, "multiplePagesToLoad is not empty")
                let pageToLoad = internal.multiplePagesToLoad[0]
                internal.multiplePagesToLoad.shift()
                loadPage(getCurrentFilter(), pageToLoad)
            }
            else {
                console.debug(Logger.log, "multiplePagesToLoad is empty")
                internal.multiplePagesToLoad = false
                appendDataToModel(internal.multipageData, true)
                restoreModelViewLastPos()
                internal.multipageData = []
            }
        }
        else {
            console.debug(Logger.log, "not multiplePagesLoading")
            if(data.length > 0) {
                console.debug(Logger.log, "data is not empty")
                appendDataToModel(data, true)
                restoreModelViewLastPos()
            } else {
                console.debug(Logger.log, "data is empty")
            }
        }
    }

    property Request filterPagedItems: Request {
        handler: dataAccess.filterPagedItems

        onSuccess: {
            console.debug(Logger.log, "filterPagedItems")
            const params = currentSas.length > 0 ? '?' + currentSas : ''

            function makeItem(item) {
                return {
                    image: res.urls[item._id] + params,
                    selected: false,
                    metadata: item
                }
            }

            let data = res.items.map(makeItem)
            pageLoader.finishLoadingPage(data, res.continuation_token)
        }

        onError: {
            console.debug(Logger.log, "filterPagedItems")
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }
}
