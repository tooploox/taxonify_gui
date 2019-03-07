import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ComboBox {
    id: root
    property var userList: []

    model: ['None'].concat(userList)
    property int indexToEmbold: -1
    font.bold: currentIndex == indexToEmbold

    delegate: MenuItem {
        width: parent.width
        text: modelData
        font.bold: index === indexToEmbold

        Material.foreground: root.currentIndex === index ? parent.Material.accent : parent.Material.foreground
        highlighted: root.highlightedIndex === index
    }

    function emboldenCurrentChoice() {
        console.log(Logger.debug, "ModifiedByFilter: emboldenCurrentChoice - index = " + currentIndex)
        indexToEmbold = currentIndex
    }

    function choice() {
        console.log(Logger.debug, "ModifiedByFilter: choice()")
        if (currentIndex === 0) {
            console.log(Logger.debug, "ModifiedByFilter: choice() - currentIndex equal to 0")
            return ''
        } else {
            console.log(Logger.debug, "ModifiedByFilter: choice() - currentIndex not equal to 0")
        }

        return model[currentIndex]
    }
}
