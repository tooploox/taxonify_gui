import QtQuick 2.12
import QtQuick.Controls 2.12

import com.microscopeit 1.0

import "qrc:/network"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    Request {

    }

    Uploader {

        Component.onCompleted: {
            console.log('completed!')
            upload("xxx");
        }
    }

    Rectangle {
        anchors.fill: parent
        color: 'red'
    }
}
