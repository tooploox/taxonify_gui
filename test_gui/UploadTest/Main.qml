import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import com.microscopeit 1.0

import "qrc:/"

ApplicationWindow {

    visible: true

    width: 800
    height: 500

    UploadForm {
        address: 'https://httpbin.org/put'
        anchors.fill: parent

        onFileSelected: {
            console.log(file)
        }

        onSuccess: {
            console.log('SUCCESS!')
            console.log(replyData)
        }
    }
}
