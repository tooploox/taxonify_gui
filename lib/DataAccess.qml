import QtQuick 2.12

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
            access_token_header = ['Authorization', 'Bearer ' + access_token]
        }

        onRefresh_tokenChanged: {
            refresh_token_header = ['Authorization', 'Bearer ' + refresh_token]
        }

        property Timer refreshTimer: Timer {
            interval: internal.tokenRefreshInterval
            running: true
            repeat: true

            onTriggered: {
                if(internal.refresh_token) {
                    internal.refresh()
                }
            }
        }

        function refresh() {
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
        var req = {
            handler: '/sas',
            method: 'GET',
            headers: internal.commonHeaders,
            params: { destination: destination }
        }
        return server.send(req, cb)
    }

    function filterItems(filter, cb) {
        var req = {
            handler: '/items',
            method: 'GET',
            headers: internal.commonHeaders,
            params: filter
        }
        return server.send(req, cb)
    }

    function filterPagedItems(filter, page, cb) {
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
        var req = {
            handler: '/items',
            method: 'POST',
            headers: internal.commonHeaders,
            params: updateList
        }
        return server.send(req,cb)
    }

    function uploadList(cb) {
        var req = {
            handler: '/upload/list',
            method: 'GET',
            headers: internal.commonHeaders
        }
        return server.send(req,cb)
    }

    function exportItems(exportCriteria, cb) {
        var req = {
            handler: '/export',
            method: 'GET',
            headers: [internal.access_token_header],
            params: exportCriteria
        }
        return server.send(req, cb)
    }

    function userList(cb) {
        var req = {
            handler: '/user/list',
            method: 'GET',
            headers: [internal.access_token_header]
        }
        return server.send(req, cb)
    }
}
