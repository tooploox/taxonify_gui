import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import com.microscopeit 1.0

ColumnLayout {

    property alias address : uploadDialog.address
    property alias token : uploadDialog.token

    UploadDialog {
       id: uploadDialog
       onSuccess: uploadButton.background.color = 'lightgreen'
       onError: uploadButton.background.color = 'lightcoral'
       onUploadStarted: uploadButton.background.color = 'lightgray'
    }

    Rectangle{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        border.color: 'lightgray'
        RowLayout{
            anchors.fill: parent

            SortingControls {
                enabled: false
            }
            DelayButton {
                id: uploadButton

                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 5

                text: 'Upload data'
                delay: 0
                progress: uploadDialog.uploadProgress

                onClicked: uploadDialog.open()
            }
        }
    }

    property alias filter: imageView.filter
    readonly property ImageView imageView: imageView

    ImageView {
        id: imageView

        Layout.fillWidth: true
        Layout.fillHeight: true

        sizeScale: tileSizeSlider.value
    }

    Rectangle {
        border.color: 'lightgray'
        Layout.fillWidth: true
        Layout.preferredHeight: 50

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Label {
                text: "Tile size:"
            }

            Slider {
                id: tileSizeSlider

                from: 0.25
                to: 2.0
                value: 1.0
                stepSize: 0.05
            }

            Label {
                text: "("+ Math.round(tileSizeSlider.value * 100) +"%)"
            }

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "Number of images loaded: " + imageView.model.count
            }
        }
    }
}
