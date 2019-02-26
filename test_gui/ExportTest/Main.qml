import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"
import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {

    visible: true

    width: exportDialog.width + 100
    height: exportDialog.height + 100

    ExportDialog {
       id: exportDialog

       onAccepted: {
           exportItems.call(exportDialog.exportCriteria)
       }
    }

    Button {
        id: exportButton

        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: 5

        text: 'Export'
        onClicked: exportDialog.open()
    }

    property var dataAccess: Item {
        property var server
        property QtObject internal: QtObject {
            property string access_token
            property var access_token_header

            onAccess_tokenChanged: {
                access_token_header = ['Authorization', 'Bearer ' + access_token]
            }
        }

        function exportItems(exportCriteria, cb) {
            console.log(exportCriteria)
            var req = {
                handler: '/export',
                method: 'GET',
                headers: [internal.access_token_header],
                params: exportCriteria
            }
            return server.send(req, cb)
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
                }
                cb(res)
            })
        }
    }

    Request {
        id: exportItems
        handler: dataAccess.exportItems

        onSuccess: exportDialog.processExportResponse(true, res)
        onError: exportDialog.processExportResponse(false, details)
    }

    Request {
        id: login
        handler: dataAccess.login
        onError: console.log('Login failed. Details: ' + JSON.stringify(details, null, 2))
    }

    Component.onCompleted: {
        const serverAddress = 'http://localhost'
        console.log('using server:', serverAddress)
        dataAccess.server = new Req.Server(serverAddress)
        const username = 'aquascopeuser'
        const password = 'hardpass'
        login.call(username, password)
    }
}
