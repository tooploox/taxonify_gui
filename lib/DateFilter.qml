import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    height: layout.height
    width: layout.width

    property var start
    property var end
    //property bool valid: true

//    property alias start: startDateField
//    property alias end: endDateField
//    property bool valid: (start.valid && end.empty) ||
//                         (start.empty && end.valid) ||
//                         (start.valid && end.valid &&
//                          (end.date - start.date >= 0))


    ColumnLayout {
        id: layout
        width: 300

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                text: 'Start time:'
            }

            TextField {
                id: startTextField
                Layout.fillHeight: true
                Layout.fillWidth: true
                readOnly: true
                onReleased: {
                    const mappedPoint = mapToItem(startDateTimePicker, 0, 0)
                    startPopup.x = mappedPoint.x
                    startPopup.y = mappedPoint.y
                    startPopup.open()
                }
            }
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                text: 'End time:'
            }

            TextField {
                id: endTextField
                Layout.fillHeight: true
                Layout.fillWidth: true
                readOnly: true
                onReleased: {
                    const mappedPoint = mapToItem(endDateTimePicker, 0, 0)
                    endPopup.x = mappedPoint.x
                    endPopup.y = mappedPoint.y
                    endPopup.open()
                }
            }
        }
    }

    Popup {
        id: endPopup
        parent: Overlay.overlay
        width: endDateTimePicker.width
        height: endDateTimePicker.height
        modal: true

        DateTimePicker {
            id: endDateTimePicker
            onDateTimePicked: {
                endPopup.close()
                endTextField.text = dateTime.toLocaleString(Qt.locale('en_GB'), Locale.ShortFormat)
                root.end = dateTime
            }
        }
    }

    Popup {
        id: startPopup
        parent: Overlay.overlay
        width: startDateTimePicker.width
        height: startDateTimePicker.height
        modal: true

        DateTimePicker {
            id: startDateTimePicker
            onDateTimePicked: {
                startPopup.close()
                startTextField.text = dateTime.toLocaleString(Qt.locale('en_GB'), Locale.ShortFormat)
                root.start = dateTime
            }
        }
    }







//    DateTextField {
//        id: startDateField
//        deltaMilliseconds: 0 // 00:00:00.000
//        description: qsTr("Start date:")
//        enabled: parent.enabled
//        dateTextColor: (parent.valid || empty) ? 'black' : 'red'
//    }

//    DateTextField {
//        id: endDateField
//        deltaMilliseconds: 24*60*60*1000-1 // 23:59:59.999
//        description: qsTr("End date:")
//        enabled: parent.enabled
//        dateTextColor: (parent.valid || empty) ? 'black' : 'red'
//    }

//    function getAcquisitionTimeAndApply(checked) {
//        if (checked && valid) {
//            let acquisitionTime = {}
//            acquisitionTime.start = start.getTimeAndApply(false)
//            acquisitionTime.end = end.getTimeAndApply(false)
//            return acquisitionTime
//        } else {
//            start.getTimeAndApply(true)
//            end.getTimeAndApply(true)
//            return null
//        }
//    }
}
