import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'

    function setHoveredItem(item) {

        let meta = item.metadata
        const allowed_properties = imageDetailsPickerDialog.pickedAttributes()

        const filtered = Object.keys(meta)
          .filter(key => allowed_properties.includes(key))
          .reduce((obj, key) => {
            obj[key] = meta[key];
            return obj;
          }, {});

        hoverLabel.text = JSON.stringify(filtered, null, 2)
    }

    FontLoader {
        id: fontLoader
        source: 'qrc:/graphics/awesome.ttf'
    }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            border.color: 'lightgray'
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                anchors.fill: parent
            }
        }
        Rectangle {
            border.color: 'lightgray'
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                id: hoverLabel
                anchors.fill: parent
                clip: true
            }
        }
        Row {
            Layout.fillWidth: true
            Layout.preferredHeight: filterButton.height

            Button {
                id: filterButton
                text: '\uf0b0'
                font.family: fontLoader.name
                font.pixelSize: 16
                width: 30
                height: width

                onClicked: imageDetailsPickerDialog.open()
            }
        }
    }

    ImageDetailsPickerDialog {
        id: imageDetailsPickerDialog
        onAccepted: {
            console.log(pickedAttributes())
        }
    }

}
