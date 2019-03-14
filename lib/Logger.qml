pragma Singleton
import QtQuick 2.12

QtObject {
    readonly property LoggingCategory log: LoggingCategory { name: "logger" }
}
