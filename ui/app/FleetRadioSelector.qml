import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../imports"
import "../shared"
import "../shared/status"

StatusRadioButtonRow {
    property string fleetName: ""
    text: fleetName
    buttonGroup: fleetSettings
    checked: appSettings.fleet === text
    onRadioCheckedChanged: {
        if (checked) {
            if (appSettings.fleet === fleetName) return;
            appSettings.fleet = fleetName
            close();
        }
    }
}

