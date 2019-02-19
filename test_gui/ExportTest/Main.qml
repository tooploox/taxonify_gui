import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"

ApplicationWindow {

    visible: true

    width: exportDialog.width + 100
    height: exportDialog.height + 100

    ExportDialog {
       id: exportDialog
    }

    Button {
        id: exportButton

        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: 5

        text: 'Export'
        onClicked: exportDialog.open()
    }
}
