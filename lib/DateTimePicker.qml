import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Layouts 1.12

Item {
    height: layout.height
    property var dateTime: {
        let date = calendar.selectedDate
        let hour = hoursTumbler.currentIndex
        let minute = minutesTumbler.currentIndex
        date.setHours(hour)
        date.setMinutes(minute)
        date.setSeconds(0)
        date.setMilliseconds(0)
        return date
    }

    signal dateTimePicked()

    function formatText(count, modelData) {
        return modelData.toString().length < 2 ? "0" + modelData : modelData;
    }

    Component {
        id: delegateComponent
        Label {
            id: textLabel
            text: formatText(Tumbler.tumbler.count, modelData)
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        border.color: 'black'

        ColumnLayout {
            id: layout

            OldControls.Calendar {
                id: calendar
                Layout.fillHeight: true
                Layout.fillWidth: true
                frameVisible: false
                locale: Qt.locale("en_GB")
            }

            Rectangle {
                id: frame
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                height: 100

                Row {
                    Layout.fillWidth: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.alignment: Qt.AlignCenter
                    height: frame.height

                    Tumbler {
                        id: hoursTumbler
                        model: 24
                        delegate: delegateComponent
                        Layout.alignment: Qt.AlignCenter
                        height: frame.height
                        visibleItemCount: 5
                    }

                    Tumbler {
                        id: minutesTumbler
                        model: 60
                        delegate: delegateComponent
                        Layout.alignment: Qt.AlignCenter
                        height: frame.height
                        visibleItemCount: 5
                    }
                }
            }

            Button {
                Layout.fillWidth: true
                text: "OK"

                onClicked: dateTimePicked()
            }
        }
    }
}



