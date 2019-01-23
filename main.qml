import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

//import "components/requests.js" as Req
import "components/qml/requests.js" as Req

ApplicationWindow {
    visible: true
    width: 640 * 2
    height: 480 * 1.5
    title: qsTr("Aquascope Data Browser")

    DataModel {
        id: itemsModel
    }

    RowLayout {
        anchors.fill: parent

        FilteringPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }

        ImageViewAndControls {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AnnotationPane {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
        }
    }
}

