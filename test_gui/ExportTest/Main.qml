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
        property var server: new Req.Server('http://localhost:5000')
        property QtObject internal: QtObject {
            property string access_token_header: ''
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
    }

    Request {
        id: exportItems
        handler: dataAccess.exportItems

        onSuccess: exportDialog.processExportResponse(true, res)
        onError: exportDialog.processExportResponse(false, details)
    }
}
