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
        Logger.log("PageLoader: getNumberOfLoadedPages()")
        return internal.pagesLoaded
    }

    function nextPageNumber() {
        Logger.log("PageLoader: nextPageNumber()")
        return internal.pagesLoaded + 1
    }

    function resetPagesStatus() {
        Logger.log("PageLoader: resetPagesStatus()")
        internal.pagesLoaded = 0
        internal.lastPageLoaded = false
    }

    function loadNextPage(filter){
        Logger.log("PageLoader: loadNextPage(filter='" + JSON.stringify(filter) + "')")
        let pageNo = nextPageNumber()
        console.log("Load Next page: " + pageNo)
        loadPage(filter, pageNo)
    }

    function loadPage(filter, pageNumber){
        Logger.log("PageLoader: loadPage(filter='" + JSON.stringify(filter) + "', pageNumber=" + pageNumber + ")")
        internal.pageLoadingInProgress = true
        filterPagedItems.call(filter, pageNumber)
    }

    function loadPages(filter, pagesToLoad){
        Logger.log("PageLoader: loadPages(filter='" + JSON.stringify(filter) + "', pagesToLoad=" + JSON.stringify(pagesToLoad) + ")")
        resetPagesStatus()
        internal.multiplePagesLoading = true

        const pagesRange = [...Array((pagesToLoad+1)).keys()]  // Generate range 0 ... n
        internal.multiplePagesToLoad = pagesRange.slice(1)
        let pageToLoad = internal.multiplePagesToLoad[0]
        internal.multiplePagesToLoad.shift()
        loadPage(filter, pageToLoad)
    }

    function finishLoadingPage(data, continuationToken){
        Logger.log("PageLoader: finishLoadingPage(continuationToken='" + JSON.stringify(continuationToken) + "')")
        console.log("Finished loading page " + nextPageNumber())

        let loadedPage = internal.pagesLoaded
        internal.pagesLoaded += 1
        internal.lastPageLoaded = (continuationToken === undefined ? true : false)
        internal.pageLoadingInProgress = false
        if(internal.lastPageLoaded) {
            Logger.log("PageLoader: finishLoadingPage - lastPageLoaded")
            internal.multiplePagesToLoad = []
        }

        if(internal.multiplePagesLoading) {
            Logger.log("PageLoader: finishLoadingPage - multiplePagesLoading")
            if(data.length > 0) {
                Logger.log("PageLoader: data is not empty")
                internal.multipageData = internal.multipageData.concat(data)
            } else {
                Logger.log("PageLoader: data is empty")
            }

            if(internal.multiplePagesToLoad.length > 0) {
                Logger.log("PageLoader: multiplePagesToLoad is not empty")
                let pageToLoad = internal.multiplePagesToLoad[0]
                internal.multiplePagesToLoad.shift()
                loadPage(getCurrentFilter(), pageToLoad)
            }
            else {
                Logger.log("PageLoader: multiplePagesToLoad is empty")
                internal.multiplePagesToLoad = false
                appendDataToModel(internal.multipageData, true)
                restoreModelViewLastPos()
                internal.multipageData = []
            }
        }
        else {
            Logger.log("PageLoader: finishLoadingPage - not multiplePagesLoading")
            if(data.length > 0) {
                Logger.log("PageLoader: data is not empty")
                appendDataToModel(data, true)
                restoreModelViewLastPos()
            } else {
                Logger.log("PageLoader: data is empty")
            }
        }
    }

    property Request filterPagedItems: Request {
        handler: dataAccess.filterPagedItems

        onSuccess: {
            Logger.log("PageLoader: filterPagedItems succeeded")
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
            Logger.log("PageLoader: filterPagedItems failed")
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }
}
