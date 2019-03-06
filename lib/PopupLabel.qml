import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Label {
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            console.log('hello')
        }
    }
}
