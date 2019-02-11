import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:/"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    UploadForm {
        address: 'http://localhost/put'
        token: 'my-magic-token'
        anchors.fill: parent

        onFileSelected: {
            console.log(file)
        }

        onSuccess: {
            console.log('SUCCESS!')
        }
    }
}
