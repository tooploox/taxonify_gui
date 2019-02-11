import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import com.microscopeit 1.0

ColumnLayout {
    UploadDialog {
       id: upload_dialog
    }

    RowLayout{
        Rectangle{
            border.color: 'lightgray'
            Layout.fillWidth: true
            Layout.preferredHeight: 52
            RowLayout{
                anchors.fill: parent

                SortingControls {
                    enabled: false
                }
                Button {
                    text: 'Upload data'

                    Layout.alignment: Qt.AlignCenter
                    Layout.rightMargin: 5

                    onClicked: { upload_dialog.open() }
                }
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
