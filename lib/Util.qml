pragma Singleton
import QtQuick 2.12

import "network/requests.js" as Req

QtObject {
    readonly property var settingsFromFile:
        settingsPath ? Req.readJsonFromLocalFileSync(settingsPath) : null

    function getSettingVariable(key, defaultValue) {
        Logger.log("Util: getSettingVariable(key='" + key + "', defaultValue='" + defaultValue + "')")

        if(settingsFromFile) {
            Logger.log("Util: getSettingVariable - settingsFromFile")

            if (settingsFromFile && settingsFromFile[key]) {
                Logger.log("Util: getSettingVariable - key value is " + settingsFromFile[key])
                return settingsFromFile[key]
            } else {
                Logger.log("Util: getSettingVariable - key field not found in settings")
                console.log('No "' + key + '" field found in settings.')
            }
        } else {
            Logger.log("Util: getSettingVariable - Settings file not found, using default value")
            console.log('Settings file not found. Using default value for', key)
        }

        if (defaultValue !== null) {
            Logger.log("Util: getSettingVariable - default value exists")
            return defaultValue
        } else {
            Logger.log("Util: getSettingVariable - default value does not exist")
            console.log('No default provided for', key, '. Returning null')
            return null
        }
    }
}
