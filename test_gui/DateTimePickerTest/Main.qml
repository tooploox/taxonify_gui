import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    DateTimeFieldAndLabel {
        id: startDate
        width: 300
        text: 'Please choose time:'
    }
}
