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
            console.info(Logger.log, "")
            access_token_header = ['Authorization', 'Bearer ' + access_token]
        }

        onRefresh_tokenChanged: {
            console.info(Logger.log, "")
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
            console.info(Logger.log, "")
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
        console.info(Logger.log, "username='" + username + "'")

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
        console.info(Logger.log, "destination='" + destination + "'")
        var req = {
            handler: '/sas',
            method: 'GET',
            headers: internal.commonHeaders,
            params: { destination: destination }
        }
        return server.send(req, cb)
    }

    function filterItems(filter, cb) {
        console.info(Logger.log, "filter='" + JSON.stringify(filter) + "'")
        var req = {
            handler: '/items',
            method: 'GET',
            headers: internal.commonHeaders,
            params: filter
        }
        return server.send(req, cb)
    }

    function filterPagedItems(filter, page, cb) {
        console.info(Logger.log, "filter='" + JSON.stringify(filter) + "', page='" + page + "'")
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
        console.info(Logger.log, "updateList='" + JSON.stringify(updateList) + "'")
        var req = {
            handler: '/items',
            method: 'POST',
            headers: internal.commonHeaders,
            params: updateList
        }
        return server.send(req,cb)
    }

    function uploadList(cb) {
        console.info(Logger.log, "")
        var req = {
            handler: '/upload/list',
            method: 'GET',
            headers: internal.commonHeaders
        }
        return server.send(req,cb)
    }

    function exportItems(exportCriteria, cb) {
        console.info(Logger.log, "exportCriteria='" + JSON.stringify(exportCriteria) + "'")
        var req = {
            handler: '/export',
            method: 'GET',
            headers: [internal.access_token_header],
            params: exportCriteria
        }
        return server.send(req, cb)
    }

    function userList(cb) {
        console.info(Logger.log, "")
        var req = {
            handler: '/user/list',
            method: 'GET',
            headers: [internal.access_token_header]
        }
        return server.send(req, cb)
    }

    function addUser(username, cb) {
        console.info(Logger.log, "username='" + username + "'")
        var req = {
            handler: '/user/new',
            method: 'POST',
            headers: [internal.access_token_header],
            params: { username: username }
        }

        return server.send(req, cb)
    }

    function getUpload(upload_id, cb) {
        var req = {
            handler: '/upload/' + upload_id,
            method: 'GET',
            headers: [internal.access_token_header]
        }

        return server.send(req, cb)
    }

    function postTags(upload_id, tags, cb) {
        var req = {
            handler: '/upload/' + upload_id + '/tags',
            method: 'POST',
            headers: [internal.access_token_header],
            params: { tags: tags }
        }

        return server.send(req, cb)
    }
}
