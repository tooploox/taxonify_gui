import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {
    id: root
    visible: true
    width: 640 * 2
    height: 480 * 1.5
    title: qsTr("Aquascope Data Browser")
    property string defaultServerAddress: 'http://localhost:8000'

    function getServerAddress() {
        var applicationArgs = Qt.application.arguments

        if(applicationArgs.length === 2) {
            return applicationArgs[1]
        }

        if(settingsPath) {
            console.log('settings path:', settingsPath)

            var settingsObj = Req.readJsonFromLocalFileSync(settingsPath)

            if (settingsObj && settingsObj.host) {
                return settingsObj.host
            } else {
                console.log('No "host" field found in settings')
            }

        } else {
            console.log('Settings not found. Using default server address.')
        }

        return defaultServerAddress
    }

    ListModel { id: itemsModel }

    RowLayout {
        anchors.fill: parent

        FilteringPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true

            dataAccess: root.dataAccess
        }

        ImageViewAndControls {
            Layout.fillWidth: true
            Layout.fillHeight: true

            dataAccess: root.dataAccess
        }

        AnnotationPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true

            dataAccess: root.dataAccess
        }
    }

    property var dataAccess: DataAccess {}

    Component.onCompleted: {
        var serverAddress = getServerAddress()
        dataAccess.server = new Req.Server(serverAddress)
    }
}

