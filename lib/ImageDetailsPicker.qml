import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    function pickedAttributes() {
        return {
            taxonomy: taxonomyDetails.pickedAttributes(),
            morphometry: morphometricDetails.pickedAttributes(),
            additionalAttributes: additionalAttributesDetails.pickedAttributes()
        }
    }

    RowLayout {
        anchors.fill: parent

        ImageDetailsList {
            id: taxonomyDetails
            Layout.fillWidth: true
            Layout.fillHeight: true
            detailsArray: FilteringAttributes.taxonomyAttributes
            title: "Taxonomy"
        }

        ImageDetailsList {
            id: morphometricDetails
            Layout.fillWidth: true
            Layout.fillHeight: true
            detailsArray: FilteringAttributes.morphometricAttributes
            title: "Morphometry"
        }

        ImageDetailsList {
            id: additionalAttributesDetails
            Layout.fillWidth: true
            Layout.fillHeight: true
            detailsArray: FilteringAttributes.filteringAttributes
            title: "Additional attributes"
        }
    }
}
