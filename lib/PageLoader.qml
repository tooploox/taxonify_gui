import QtQuick 2.12

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
   property var appendDataToModel: undefined

   // Function which restore last position of viewing model
   // Signature: restoreModelViewLastPos()
   property var restoreModelViewLastPos: undefined

   // Request type object for getting paged items with defined filter
   property var filterPagedItemsReq: undefined

   // Public methods
   function getNumberOfLoadedPages() { return internal.pagesLoaded }
   function nextPageNumber() { return internal.pagesLoaded + 1 }

   function resetPagesStatus() {
       internal.pagesLoaded = 0
       internal.lastPageLoaded = false
   }

   function loadNextPage(filter){
       let pageNo = nextPageNumber()
       console.log("Load Next page: " + pageNo)
       loadPage(filter, pageNo)
   }

   function loadPage(filter, pageNumber){
     internal.pageLoadingInProgress = true
     filterPagedItemsReq.call(filter, pageNumber)
   }

   function loadPages(filter, pagesToLoad){
       resetPagesStatus()
       internal.multiplePagesLoading = true

       const pagesRange = [...Array((pagesToLoad+1)).keys()]  // Generate range 0 ... n
       internal.multiplePagesToLoad = pagesRange.slice(1)
       let pageToLoad = internal.multiplePagesToLoad[0]
       internal.multiplePagesToLoad.shift()
       loadPage(filter, pageToLoad)
   }

   function finishLoadingPage(data, continuationToken){
       console.log("Finished loading page " + nextPageNumber())

       let loadedPage = internal.pagesLoaded
       internal.pagesLoaded += 1
       internal.lastPageLoaded = (continuationToken === undefined ? true : false)
       internal.pageLoadingInProgress = false
       if(internal.lastPageLoaded) {
           internal.multiplePagesToLoad = []
       }

       if(internal.multiplePagesLoading) {
           if(data.length > 0) {
               internal.multipageData = internal.multipageData.concat(data)
           }

           if(internal.multiplePagesToLoad.length > 0) {
             let pageToLoad = internal.multiplePagesToLoad[0]
             internal.multiplePagesToLoad.shift()
             loadPage(getCurrentFilter(), pageToLoad)
           }
           else {
               internal.multiplePagesToLoad = false
               appendDataToModel(internal.multipageData, true)
               restoreModelViewLastPos()
               internal.multipageData = []
           }
       }
       else {
           if(data.length > 0) {
               appendDataToModel(data, true)
               restoreModelViewLastPos()
           }
       }
   }
}
