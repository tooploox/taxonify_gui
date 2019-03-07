pragma Singleton
import QtQuick 2.12

import "network/requests.js" as Req

QtObject {
    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    function getSettingVariable(key, defaultValue) {
        console.log(Logger.debug, "Util: getSettingVariable(key='" + key + "', defaultValue='" + defaultValue + "')")

        if(settingsFromFile) {
            console.log(Logger.debug, "Util: getSettingVariable - settingsFromFile")

            if (settingsFromFile && settingsFromFile[key]) {
                console.log(Logger.debug, "Util: getSettingVariable - key value is " + settingsFromFile[key])
                return settingsFromFile[key]
            } else {
                console.log(Logger.debug, "Util: getSettingVariable - key field not found in settings")
                console.log('No "' + key + '" field found in settings.')
            }
        } else {
            console.log(Logger.debug, "Util: getSettingVariable - Settings file not found, using default value")
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultValue !== null) {
            console.log(Logger.debug, "Util: getSettingVariable - default value exists")
            return defaultValue
        } else {
            console.log(Logger.debug, "Util: getSettingVariable - default value does not exist")
            console.log('No default provided for', key, '. Returning null')
            return null
        }
    }
}
