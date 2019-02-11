import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/network"
import "qrc:/network/requests.js" as Req

ApplicationWindow {
    visible: true
    id: mainApp
    property ApplicationWindow appWindow : mainApp

    width: 640 * 2
    height: 480 * 1.5

    title: qsTr("Aquascope Data Browser")

    readonly property var defaultSettings: ({
        host: 'http://localhost',
        username: 'aq_user',
        password : 'hardpass'
    })

    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    property var currentFilter: {}
    property string currentSas: ''
    property bool viewPopulated: false

    function getSettingVariable(key) {
        if(settingsFromFile) {
            if (settingsFromFile && settingsFromFile[key]) {
                return settingsFromFile[key]
            } else {
                console.log('No"' + key + '" field found in settings.')
            }
        } else {
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultSettings[key]) {
            return defaultSettings[key]
        } else {
            console.log('key ' + key
                        + ' not found in dafaults array. Returning null')
            return null
        }
    }

    RowLayout {
        anchors.fill: parent

        FilteringPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true

            onAppliedClicked: {
                currentFilter = filter
                filterItems.call(filter)
            }

        }

        ImageViewAndControls {

            id: imageViewAndControls

            Layout.fillWidth: true
            Layout.fillHeight: true

            filter: ((criteria) => {
                         return (item) => {
                             for (let c in criteria) {
                                 if (item.metadata[c] !== criteria[c])
                                 return false
                             }
                             return true
                         }

                     })(annotationPane.criteria)
        }

        AnnotationPane {
            id: annotationPane
            Layout.preferredWidth: 300
            Layout.fillHeight: true

            onApplyClicked: {

                const model = imageViewAndControls.imageView.model

                const toUpdate = []

                function makeCopy(obj) {
                    return JSON.parse(JSON.stringify(obj))
                }

                for(let i = 0; i < model.count; i++) {

                    const item = model.get(i)

                    if(!imageViewAndControls.filter(item) && item.selected) {

                        const current = makeCopy(item.metadata)
                        const update = Object.assign(makeCopy(item.metadata),
                                                     criteria)

                        const updateItem = {
                            current: current,
                            update: update
                        }

                        toUpdate.push(updateItem)
                    }

                    // remove selection
                    item.selected = false
                }
                if (toUpdate.length > 0) {
                    updateItems.call(toUpdate)
                }
            }
        }
    }

    property var dataAccess: DataAccess {}

    Request {
        id: login

        handler: dataAccess.login

        onSuccess: sas.call('processed')
        onError: console.log('Login failed. Details: ' + details)
    }

    Request {
        id: sas

        handler: dataAccess.sas

        onSuccess: {
            currentSas = res.token
            if (!viewPopulated) {
                filterItems.call({}) // to populate view just once
            }
        }

        onError: {
            console.log('sas failed. Details: ' + details)
        }
    }

    Timer {
        interval: 1000 * 60 * 30 // 30 min
        running: true
        repeat: true

        onTriggered: {
            sas.call('processed')
        }
    }

    Request {
        id: filterItems

        handler: dataAccess.filterItems

        onSuccess: {
            const params = currentSas.length > 0 ? '?' + currentSas : ''

            let data = []

            for (let item of res.items) {
                const modelItem = {
                    image: res.urls[item._id] + params,
                    selected: false,
                    metadata: item
                }
                data.push(modelItem)
            }

            viewPopulated = true
            imageViewAndControls.imageView.setData(data)
        }

        onError: {
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }

    Request {
        id: updateItems

        handler: dataAccess.updateItems

        onSuccess: filterItems.call(currentFilter)

        onError: {
            // TODO
            console.log("Updating annotations failed!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Component.onCompleted: {
        const serverAddress = getSettingVariable('host')
        dataAccess.server = new Req.Server(serverAddress)
        const username = getSettingVariable('username')
        const password = getSettingVariable('password')
        login.call(username, password)
    }
}

