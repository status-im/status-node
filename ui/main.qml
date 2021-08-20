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

import "./shared"
import "./shared/status"
import "./shared/status/core"
import "./imports"
import "./app"

StatusWindow {
    property bool popupOpened: false

    function openPopup(popupComponent, params = {}) {
        const popup = popupComponent.createObject(applicationWindow, params);
        popup.open()
    }

    Universal.theme: Universal.System

    property bool useWakuV2:  appSettings.fleet == "wakuv2.prod" || appSettings.fleet == "wakuv2.test"

    function startNode(){
        let fleetConfig = JSON.parse(nodeModel.fleetConfig)["fleets"][appSettings.fleet];
        let boot = [];
        let static = [];
        let mailservers = [];
        let wakuV2Nodes = [];

        if(applicationWindow.useWakuV2){
            wakuV2Nodes = Object.keys(fleetConfig["waku"]).map(function(k){return fleetConfig["waku"][k]});
        } else {
            boot = Object.keys(fleetConfig["boot"]).map(function(k){return fleetConfig["boot"][k]});
            static = Object.keys(fleetConfig["whisper"]).map(function(k){return fleetConfig["whisper"][k]});
            mailservers = Object.keys(fleetConfig["mail"]).map(function(k){return fleetConfig["mail"][k]});
        }

        let configJSON = {
            "EnableNTPSync": true,
            "KeyStoreDir": appSettings.dataDir + "keystore",
            "NetworkId": appSettings.networkId,
            "LogEnabled": appSettings.logEnabled,
            "LogFile": appSettings.logFile,
            "LogLevel": appSettings.logLevel,
            "ListenAddr": "0.0.0.0:30303",    // TODO: Add setting?
            "HTTPEnabled": true, // TODO: Add setting
            "HTTPHost": "127.0.0.1", // TODO: Add setting
            "DataDir": appSettings.dataDir,
            "HTTPPort": 8545, // TODO: Add setting
            "APIModules": "eth,web3,admin",  // TODO: Add setting
            "RegisterTopics": ["whispermail"],
            "WakuConfig": {
                "Enabled": !applicationWindow.useWakuV2,
                "DataDir": "./waku",
                "BloomFilterMode": false,
                "LightClient": false,
                "MinimumPoW": 0.001,
                "FullNode": true
            },
            "WakuV2Config": {
                "Enabled": applicationWindow.useWakuV2,
                "Host": "0.0.0.0", // TODO: Add setting
                "Port": 60000 // TODO: Add setting
            },
            "RequireTopics": {
                "whisper": {
                    "Max": 2,
                    "Min": 2
                }
            },
            "NoDiscovery": applicationWindow.useWakuV2 ? true : false,
            "Rendezvous": false,
            "ClusterConfig": {
                "Enabled": true,
                "Fleet": appSettings.fleet,
                "RendezvousNodes": [],
                "BootNodes": boot,
                "TrustedMailServers": mailservers,
                "PushNotificationsServers": [],
                "StaticNodes": static,
                "WakuNodes": wakuV2Nodes,
                "WakuStoreNodes": wakuV2Nodes
            }
        }
        
        nodeModel.startNode(JSON.stringify(configJSON))
    }


    Settings {
        id: appSettings
        fileName: nodeModel.dataDir + "/qt/settings"
        property string locale: "en"
        property int theme: 2
        property int networkId: 1
        property bool logEnabled: true
        property string logFile: "geth.log"
        property string logLevel: "INFO"
        property string dataDir: nodeModel.dataDir
        property string fleet: Constants.eth_prod
        property bool useWakuV2: false

        Component.onCompleted: {
            timer.setTimeout(function(){
                startNode()
            }, 250);            
        }
    }

    Timer {
        id: timer
    }

    id: applicationWindow
    objectName: "mainWindow"
    width: 500
    height: 450
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    color: Style.current.background
    title: {
        // Set application settings
        //% "Status Desktop"
        Qt.application.name = "Status Node"
        Qt.application.organization = "Status"
        Qt.application.domain = "status.im"
        return Qt.application.name
    }
    visible: true

    //! Workaround for custom QQuickWindow
    Connections {
        target: applicationWindow
        onClosing: {
            applicationWindow.visible = false
            close.accepted = false
        }

        onActiveChanged: {
            if (applicationWindow.active) {
                // QML doesn't have a function to hide notifications, but this does the trick
                systemTray.hide()
                systemTray.show()
            }
        }
    }

    // The easiest way to get current system theme (is it light or dark) without using
    // OS native methods is to check lightness (0 - 1.0) of the window color.
    // If it's too high (0.85+) means light theme is an active.
    SystemPalette {
        id: systemPalette
        function isCurrentSystemThemeDark() {
            return window.hslLightness < 0.85
        }
    }

    function changeThemeFromOutside() {
        Style.changeTheme(appSettings.theme, systemPalette.isCurrentSystemThemeDark())
    }

    Component.onCompleted: {
        Style.changeTheme(appSettings.theme, systemPalette.isCurrentSystemThemeDark())
        setX(Qt.application.screens[0].width / 2 - width / 2);
        setY(Qt.application.screens[0].height / 2 - height / 2);

        applicationWindow.updatePosition();
    }    

    SystemTrayIcon {
        id: systemTray
        visible: true
        icon.source: {
            if (production) {
                if (Qt.platform.os == "osx")
                    return "shared/img/status-logo-round-rect.svg"
                else
                    return "shared/img/status-logo-circle.svg"
            } else {
                if (Qt.platform.os == "osx")
                    return "shared/img/status-logo-dev-round-rect.svg"
                else
                    return "shared/img/status-logo-dev-circle.svg"
            }
        }

        function openStatusWindow() {
            applicationWindow.show()
            applicationWindow.raise()
            applicationWindow.requestActivate()
        }

        menu: Menu {
            MenuItem {
                //% "Open Status"
                text: qsTrId("open-status")
                onTriggered: {
                    systemTray.openStatusWindow()
                }
            }
            
            MenuSeparator {
            }

            MenuItem {
                visible: !nodeModel.nodeActive
                text: qsTr("Start node")
                onTriggered: {
                    startNode()
                }
            }

            MenuItem {
                visible: nodeModel.nodeActive
                text: qsTr("Stop node")
                onTriggered: {
                    nodeModel.stopNode()
                }
            }

            MenuItem {
                //% "Quit"
                text: qsTrId("quit")
                onTriggered: Qt.quit()
            }
        }

        onActivated: {
            if (reason !== SystemTrayIcon.Context) {
                openStatusWindow()
            }
        }
    }

    AppLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Style.current.padding
        anchors.rightMargin: Style.current.padding
    }

    MacTrafficLights {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 13

        visible: Qt.platform.os === "osx" && !applicationWindow.isFullScreen

        onClose: {
            applicationWindow.visible = false;
        }

        onMinimised: {
            applicationWindow.showMinimized()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
