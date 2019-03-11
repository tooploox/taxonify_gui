pragma Singleton
import QtQuick 2.12

Item {

    readonly property alias debug: dbg
    readonly property alias info: inform

    LoggingCategory {
        id: dbg
        name: "logger.debug"
    }

    LoggingCategory {
        id: inform
        name: "logger.info"
    }
}
