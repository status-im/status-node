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
import "./imports"
import "./app"

StatusWindow {
    property bool popupOpened: false

    function openPopup(popupComponent, params = {}) {
        const popup = popupComponent.createObject(applicationWindow, params);
        popup.open()
    }

    Universal.theme: Universal.System

    function genHexString(len) {
        const hex = '0123456789ABCDEF';
        let output = '';
        for (let i = 0; i < len; ++i) {
            output += hex.charAt(Math.floor(Math.random() * hex.length));
        }
        return output;
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
        property string nodeKey: genHexString(64)
        property string bloomLevel: "full"
        property bool useWakuV2: false
    }

    id: applicationWindow
    objectName: "mainWindow"
    width: 500
    height: 400
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

    signal navigateTo(string path)
    

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
