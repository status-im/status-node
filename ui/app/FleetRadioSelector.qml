import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../imports"
import "../shared"
import "../shared/status"

StatusRadioButtonRow {
    property string fleetName: ""
    property string newFleet: ""
    text: fleetName
    buttonGroup: fleetSettings
    checked: appSettings.fleet === text
    onRadioCheckedChanged: {
        if (checked) {
            if (appSettings.fleet === fleetName) return;
            newFleet = fleetName;
            openPopup(confirmDialogComponent)
        }
    }

    Component {
        id: confirmDialogComponent
        ConfirmationDialog {
            //% "Warning!"
            title: qsTrId("close-app-title")
            //% "Change fleet to %1"
            confirmationText: qsTrId("change-fleet-to--1").arg(newFleet)
            onConfirmButtonClicked: {
                appSettings.fleet = newFleet
            }
            onClosed: {
                destroy();
            }
        }
    }
}

