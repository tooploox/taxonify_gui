import QtQuick 2.12

import "qrc:/"
import "qrc:/network/requests.js" as Req


// Sample data access object, should be replaced with requests aligned with
// aquascope backend specification

QtObject {

    property var server: null

    property QtObject internal: QtObject {

        readonly property int tokenRefreshInterval: 1000 * 60 * 10 // 10 min

        property string access_token
        property string refresh_token

        property var access_token_header
        property var refresh_token_header

        readonly property var compressHeader: ['Accept-Encoding', 'gzip, deflate']
        readonly property var commonHeaders: [access_token_header, compressHeader]

        onAccess_tokenChanged: {
            console.log(Logger.debug, "DataAccess: Access token changed")
            access_token_header = ['Authorization', 'Bearer ' + access_token]
        }

        onRefresh_tokenChanged: {
            console.log(Logger.debug, "DataAccess: Refresh token changed")
            refresh_token_header = ['Authorization', 'Bearer ' + refresh_token]
        }

        property Timer refreshTimer: Timer {
            interval: internal.tokenRefreshInterval
            running: true
            repeat: true

            onTriggered: {
                console.log(Logger.debug, "DataAccess: Refresh timer triggered")
                if(internal.refresh_token) {
                    console.log(Logger.debug, "DataAccess: Refreshing internal")
                    internal.refresh()
                }
            }
        }

        function refresh() {
            console.log(Logger.debug, "DataAccess: refresh()")
            var req = {
                handler: '/user/refresh',
                method: 'POST',
                headers: [internal.refresh_token_header]
            }
            return server.send(req, function(res) {
                if(res.status >= 200 && res.status < 300 && res.body !== null) {
                    internal.access_token = res.body.access_token
                }
            })
        }
    }

    function login(username, password, cb) {
        console.log(Logger.debug, "DataAccess: login(username='" + username + "')")
        var req = {
            handler: '/user/login',
            method: 'POST',
            params: { username: username, password: password }
        }

        return server.send(req, function(res) {
            if(res.status === 200 && res.body !== null) {
                internal.access_token = res.body.access_token
                internal.refresh_token = res.body.refresh_token
            }
            cb(res)
        })
    }

    function sas(destination, cb) {
        console.log(Logger.debug, "DataAccess: sas(destination='" + destination + "')")
        var req = {
            handler: '/sas',
            method: 'GET',
            headers: internal.commonHeaders,
            params: { destination: destination }
        }
        return server.send(req, cb)
    }

    function filterItems(filter, cb) {
        console.log(Logger.debug, "DataAccess: filter(filter='" + JSON.stringify(filter) + "')")
        var req = {
            handler: '/items',
            method: 'GET',
            headers: internal.commonHeaders,
            params: filter
        }
        return server.send(req, cb)
    }

    function filterPagedItems(filter, page, cb) {
        console.log(Logger.debug, "DataAccess: filterPagedItems(filter='" + JSON.stringify(filter) + "', page='" + page + ")")
        filter.continuation_token = page
        console.log('about to send filter: ', JSON.stringify(filter))
        var req = {
            handler: '/items/paged',
            method: 'GET',
            headers: [internal.access_token_header],
            params: filter
        }

        return server.send(req, cb)
    }

    function updateItems(updateList, cb) {
        console.log(Logger.debug, "DataAccess: updateItems(updateList='" + JSON.stringify(updateList) + "')")
        var req = {
            handler: '/items',
            method: 'POST',
            headers: internal.commonHeaders,
            params: updateList
        }
        return server.send(req,cb)
    }

    function uploadList(cb) {
        console.log(Logger.debug, "DataAccess: uploadList()")
        var req = {
            handler: '/upload/list',
            method: 'GET',
            headers: internal.commonHeaders
        }
        return server.send(req,cb)
    }

    function exportItems(exportCriteria, cb) {
        console.log(Logger.debug, "DataAccess: exportItems(exportCriteria='" + JSON.stringify(exportCriteria) + "')")
        var req = {
            handler: '/export',
            method: 'GET',
            headers: [internal.access_token_header],
            params: exportCriteria
        }
        return server.send(req, cb)
    }

    function userList(cb) {
        console.log(Logger.debug, "DataAccess: userList()")
        var req = {
            handler: '/user/list',
            method: 'GET',
            headers: [internal.access_token_header]
        }
        return server.send(req, cb)
    }

    function addUser(username, cb) {
        var req = {
            handler: '/user/new',
            method: 'POST',
            headers: [internal.access_token_header],
            params: { username: username }
        }

        return server.send(req, cb)
    }
}
