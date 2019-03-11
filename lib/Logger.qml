pragma Singleton
import QtQuick 2.12

Item {
    readonly property alias log: logger

    LoggingCategory {
        id: logger
        name: "logger"
    }
}
