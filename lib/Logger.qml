pragma Singleton
import QtQuick 2.12

Item {

    readonly property alias debug: dbg

    LoggingCategory {
        id: dbg
        name: "logger.debug"
    }

}
