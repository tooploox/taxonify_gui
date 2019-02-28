import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    RowLayout {
        width: 300

        Label {
            text: 'Please choose time:'
        }

        DateTimeField {
            id: dateField
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
