import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/requests.js" as Req

import Application 1.0 as App


ApplicationWindow {
    visible: true
    width: 640 * 2
    height: 480 * 1.5
    title: qsTr("Aquascope Data Browser")

    DataModel {
        id: itemsModel
    }

    RowLayout {
        anchors.fill: parent

        FilteringPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }

        ImageViewAndControls {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AnnotationPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }
    }

    DataAccess {
        id: dataAccess

//         Component.onCompleted: {
//            const serverAddress = App.Configuration.serverAddress()
//            server = new Req.Server(serverAddress)
//        }
    }
}

