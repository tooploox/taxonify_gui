pragma Singleton
import QtQuick 2.12

import "network/requests.js" as Req

QtObject {
    property string settingsPath
    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    function getSettingVariable(key, defaultValue) {
        if(settingsFromFile) {
            if (settingsFromFile && settingsFromFile[key]) {
                return settingsFromFile[key]
            } else {
                console.log('No "' + key + '" field found in settings.')
            }
        } else {
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultValue !== null) {
            return defaultValue
        } else {
            console.log('No default provided for', key, '. Returning null')
            return null
        }
    }
}
