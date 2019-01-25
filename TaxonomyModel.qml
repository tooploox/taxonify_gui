import QtQuick 2.0

QtObject {
    property var tree: ({})
    signal treeLoaded

    Component.onCompleted: {
        var rawFile = new XMLHttpRequest();
        rawFile.open("GET", "qrc:/taxonomy_hierarchy.json", false);
        rawFile.onload = function ()
        {
            tree = JSON.parse(rawFile.responseText);
        }
        rawFile.send(null);
        treeLoaded();
    }
}
