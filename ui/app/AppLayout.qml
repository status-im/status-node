import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Qt.labs.platform 1.1
import QtQml.StateMachine 1.14 as DSM
import Qt.labs.settings 1.0
import QtQuick.Window 2.12
import QtQml 2.13
import QtQuick.Window 2.0
import QtQuick.Controls.Universal 2.12

import DotherSide 0.1

import "../shared"
import "../shared/status"
import "../shared/status/core"

import "../imports"

Column {
    id: root

    spacing: 5

    FleetsModal {
        id: fleetModal
    }

    StatusSectionDescItem {
        name: qsTr("Enode Address")
        description: "enode://" + nodeModel.publicKey + "@" + nodeModel.ipAddress + ":30303"
    }

    StatusSectionDescItem {
        name: qsTr("Peers")
        description: nodeModel.peerSize
    }

    StatusSectionDescItem {
        //% "App version"
        name: qsTrId("version")
        //% "Version: %1"
        description: qsTrId("version---1").arg(nodeModel.currentVersion)
    }

    Rate {}

    StatusSettingsLineButton {
        //% "Fleet"
        text: qsTrId("fleet")
        currentValue: appSettings.fleet
        isEnabled: !nodeModel.nodeActive
        onClicked: {
           fleetModal.open()
        }
    }

    Connections {
        target: nodeModel
        onNodeActiveChanged: {
            startNodeBtn.enabled = true
        }
    }

    StatusSettingsLineButton {
        id: startNodeBtn
        text: qsTr("Start Node")
        isSwitch: true
        switchChecked: nodeModel.nodeActive
        onClicked: {
            enabled = false
            if(switchChecked){
                nodeModel.stopNode();
                return
            }

            startNode()
        }
    }

    StyledText {
        text: qsTr("Make sure that the address %1 and %2 are available from the internet!").arg(nodeModel.ipAddress).arg(!useWakuV2 ? "UDP port 30303" : "TCP port 60000")
        anchors.right: parent.right
        anchors.rightMargin: Style.current.padding
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 12
        color: Style.current.secondaryText
        wrapMode: TextEdit.Wrap
    }
}