import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4 as OldControls
import QtQuick.Layouts 1.12

Rectangle {
    height: box.height
    width: box.width
    property bool dateCleared: true
    color: 'transparent'

    property var dateTime: {
        if (dateCleared) {
            return null
        }

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
        id: box
        width: layout.width
        height: layout.height
        color: 'transparent'

        ColumnLayout {
            id: layout
            spacing: 1

            OldControls.Calendar {
                id: calendar
                Layout.fillHeight: true
                Layout.fillWidth: true
                frameVisible: false
                locale: Util.locale
            }

            Rectangle {
                id: frame
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                height: 100

                Row {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    anchors.horizontalCenter: parent.horizontalCenter

                    Tumbler {
                        id: hoursTumbler
                        height: frame.height
                        model: 24
                        delegate: delegateComponent
                        visibleItemCount: 5
                    }

                    Tumbler {
                        id: minutesTumbler
                        height: frame.height
                        model: 60
                        delegate: delegateComponent
                        visibleItemCount: 5
                    }
                }
            }

            RowLayout {
                // out style creates big gap between rect above
                // and buttons, hence negative margin
                Layout.topMargin: -5
                Layout.fillWidth: true
                Layout.fillHeight: true

                Button {
                    Layout.preferredWidth: calendar.width / 2
                    text: "Clear"
                    onClicked: {
                        console.debug(Logger.log, "Clear")
                        dateCleared = true
                        dateTimePicked()
                    }
                }

                Button {
                    Layout.fillWidth: true
                    text: "OK"
                    onClicked: {
                        console.debug(Logger.log, "OK")
                        dateCleared = false
                        dateTimePicked()
                    }
                }
            }
        }
    }
}



