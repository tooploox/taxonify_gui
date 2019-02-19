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

                onAppliedClicked: {
                    currentFilter = filter
                    filterItems.call(filter)
                }
            }

        }

        ColumnLayout {
            Layout.fillHeight: true

            CheckBox {
                checked: false
                enabled: false
                text: "Include images"
            }

        }

    }






}
