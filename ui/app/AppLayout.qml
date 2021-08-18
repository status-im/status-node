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
import "../imports"

Column {
    id: generalColumn

    FleetsModal {
        id: fleetModal
    }

    StatusSectionHeadline {
        //% "Bloom filter level"
        text: qsTrId("bloom-filter-level")
        topPadding: Style.current.bigPadding
        bottomPadding: Style.current.padding
    }

    Row {
        spacing: 11
        
        ButtonGroup {
            id: bloomGroup
        }

        BloomSelectorButton {
            id: btnBloomLight
            buttonGroup: bloomGroup
            enabled: !nodeModel.nodeActive
            checkedByDefault: appSettings.bloomLevel == "light"
            //% "Light Node"
            btnText: qsTrId("light-node")
            onToggled: {
                if (appSettings.bloomLevel != "light") {
                    appSettings.bloomLevel = "light";
                } else {
                    btnBloomLight.click()
                }
            }
        }

        BloomSelectorButton {
            id: btnBloomNormal
            enabled: !nodeModel.nodeActive
            buttonGroup: bloomGroup
            checkedByDefault: appSettings.bloomLevel == "normal"
            //% "Normal"
            btnText: qsTrId("normal")
            onToggled: {
                if (appSettings.bloomLevel != "normal") {
                    appSettings.bloomLevel = "normal";
                } else {
                    btnBloomNormal.click()
                }
            }
        }

        BloomSelectorButton {
            id: btnBloomFull
            enabled: !nodeModel.nodeActive
            buttonGroup: bloomGroup
            checkedByDefault: appSettings.bloomLevel == "full"
            //% "Full Node"
            btnText: qsTrId("full-node")
            onToggled: {
                if (appSettings.bloomLevel != "full") {
                    appSettings.bloomLevel = "full";
                } else {
                    btnBloomFull.click()
                }
            }
        }
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

            let fleetConfig = JSON.parse(nodeModel.fleetConfig)["fleets"][appSettings.fleet];
            let boot = [];
            let mailservers = [];
            let wakuV2Nodes = [];
            let useWakuV2 = appSettings.fleet == "wakuv2.prod" || appSettings.fleet == "wakuv2.test";

            if(useWakuV2){
                wakuV2Nodes = Object.keys(fleetConfig["waku"]).map(function(k){return fleetConfig["waku"][k]});
            } else {
                boot =  Object.keys(fleetConfig["boot"]).map(function(k){return fleetConfig["boot"][k]});
                boot = boot.concat(Object.keys(fleetConfig["whisper"]).map(function(k){return fleetConfig["whisper"][k]}));
                mailservers = Object.keys(fleetConfig["mail"]).map(function(k){return fleetConfig["mail"][k]});
            }

            let configJSON = {
            "EnableNTPSync": true,
            "KeyStoreDir": appSettings.dataDir + "/keystore",
            "NetworkId": appSettings.networkId,
            "LogEnabled": appSettings.LogEnabled,
            "LogFile": appSettings.LogFile,
            "LogLevel": appSettings.logLevel,
            "ListenAddr": "0.0.0.0:30303",    // TODO: Add setting
            "HTTPEnabled": true, // TODO: Add setting
            "HTTPHost": "0.0.0.0", // TODO: Add setting
            "DataDir": appSettings.dataDir,
            "HTTPPort": 8545, // TODO: Add setting
            "APIModules": "eth,web3,admin",  // TODO: Add setting
            "RegisterTopics": ["whispermail"],
            "NodeKey": appSettings.nodeKey,
            "WakuConfig": {
                "Enabled": !useWakuV2,
                "DataDir": "./waku",
                "BloomFilterMode": appSettings.bloomLevel == "normal",
                "LightClient": false,
                "MinimumPoW": 0.001,
                "FullNode": appSettings.bloomLevel == "full"
            },
            "WakuV2Config": {
                "Enabled": useWakuV2,
                "Host": "0.0.0.0", // TODO: Add setting
                "Port": 0 // TODO: Add setting
            },
            "RequireTopics": {
                "whisper": {
                    "Max": 2,
                    "Min": 2
                }
            },
            "NoDiscovery": false,//useWakuV2 ? true : false,
            "Rendezvous": false,
            "ClusterConfig": {
                "Enabled": true,
                "Fleet": appSettings.fleet,
                "RendezvousNodes": [],
                "BootNodes": boot,
                "TrustedMailServers": mailservers,
                "PushNotificationsServers": [],
                "StaticNodes": [],
                "WakuNodes": wakuV2Nodes,
                "WakuStoreNodes": wakuV2Nodes
            }
        }

        console.log(JSON.stringify(configJSON))
        nodeModel.startNode(JSON.stringify(configJSON))
        }
    }
}