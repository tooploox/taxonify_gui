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
    property string defaultServerAddress: 'http://localhost'
    property string defaultUsername: 'aq_user'
    property string defaultPassword: 'hardpass'

    property var currentFilter: {}

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

    function getUsername() {
        if(settingsPath) {
            console.log('settings path:', settingsPath)

            var settingsObj = Req.readJsonFromLocalFileSync(settingsPath)

            if (settingsObj && settingsObj.username) {
                return settingsObj.username
            } else {
                console.log('No "username" field found in settings')
            }

        } else {
            console.log('Settings not found. Using default username.')
        }

        return defaultUsername
    }

    function getPassword() {
        if(settingsPath) {
            console.log('settings path:', settingsPath)

            var settingsObj = Req.readJsonFromLocalFileSync(settingsPath)

            if (settingsObj && settingsObj.password) {
                return settingsObj.password
            } else {
                console.log('No "password" field found in settings')
            }

        } else {
            console.log('Settings not found. Using default password.')
        }

        return defaultPassword
    }

    RowLayout {
        anchors.fill: parent

        FilteringPane {
            id: filteringPane

            Layout.preferredWidth: 300
            Layout.fillHeight: true

            onAppliedClicked: {
                currentFilter = filter
                filterItemsReq.call(filter)
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

            model: ListModel {
                id: itemsModel
            }
        }

        AnnotationPane {
            id: annotationPane
            Layout.preferredWidth: 300
            Layout.fillHeight: true

            onApplyClicked: {

                const model = imageViewAndControls.model

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

                updateItems.call(toUpdate)

            }
        }
    }

    property var dataAccess: DataAccess {}

    Request {
        id: loginReq

        handler: dataAccess.login

        onSuccess: {
            console.log('login succeeded')
            filterItemsReq.call({})
        }

        onError: {
            console.log('Login failed')
        }
    }

    Request {
        id: filterItemsReq

        handler: dataAccess.filterItems

        onSuccess: {
            itemsModel.clear()
            for (let item of res['items']) {
                const modelItem = {
                    image: res['urls'][item['_id']],
                    selected: false,
                    metadata: {
                        _id: item['_id'],
                        filename: item['filename'],
                        extension: item['extension'],
                        group_id: item['group_id'],
                        empire: item['empire'],
                        kingdom: item['kingdom'],
                        phylum: item['phylum'],
                        class: item['class'],
                        order: item['order'],
                        family: item['family'],
                        genus: item['genus'],
                        species: item['species'],
                        dividing: item['dividing'],
                        dead: item['dead'],
                        with_epiphytes: item['with_epiphytes'],
                        broken: item['broken'],
                        colony: item['colony'],
                        eating: item['eating'],
                        multiple_species: item['multiple_species'],
                        cropped: item['cropped'],
                        male: item['male'],
                        female: item['female'],
                        juvenile: item['juvenile'],
                        adult: item['adult'],
                        with_eggs: item['with_eggs'],
                        acquisition_time: item['acquisition_time'],
                        image_width: item['image_width'],
                        image_height: item['image_height']
                    }
                }
                itemsModel.append(modelItem)
            }
        }

        onError: {
            console.log('error in retrieving data items. Error: '+ details.text)
        }
    }

    Request {
        id: updateItems

        handler: dataAccess.updateItems

        onSuccess: filterItemsReq.call(currentFilter)

        onError: {
            // TODO
            console.log("FAIL!")
            console.log(JSON.stringify(details, null, "  "))
        }
    }

    Component.onCompleted: {
        var serverAddress = getServerAddress()
        dataAccess.server = new Req.Server(serverAddress)
        var username = getUsername()
        var password = getPassword()
        loginReq.call(username, password)
    }
}

