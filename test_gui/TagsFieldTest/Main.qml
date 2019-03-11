import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/"

ApplicationWindow {

    visible: true

    width: 500
    height: 500

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            text: 'editable'
        }

        TagsField {
            Layout.preferredWidth: 300
            Layout.preferredHeight: 150
        }

        MenuSeparator {
            Layout.fillWidth: true
        }

        Text {
            text: 'read-only'
        }

        TagsField {
            id: readonlyTagsField
            Layout.preferredWidth: 300
            Layout.preferredHeight: 100
            readOnly: true
        }
    }

    Component.onCompleted: {
        readonlyTagsField.setTags(['tag1', 'spaced tag'])
    }
}
