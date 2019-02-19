import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.fillHeight: true

            FilteringPane {
                Layout.preferredWidth: 300
                Layout.fillHeight: true

                withApplyButton: false

                onAppliedClicked: {
                    currentFilter = filter
                    filterItems.call(filter)
                }
            }

        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: 5

            CheckBox {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5

                checked: false
                enabled: false
                text: "Include images"
            }

            CheckBox {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5

                checked: true
                enabled: true
                text: "Limit results to first 1000."
            }

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                Layout.leftMargin: 5


                text: "By clicking \"OK\" you will download data that matches provided criteria."
            }
        }

    }






}
