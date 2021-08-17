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
import "./imports"

StatusWindow {
    property bool popupOpened: false

    Universal.theme: Universal.System

    Settings {
        id: globalSettings
        category: "global"
        fileName: profileModel.settings.globalSettingsFile
        property string locale: "en"
        property int theme: 2

        Component.onCompleted: {
            profileModel.changeLocale(locale)
        }
    }

    id: applicationWindow
    objectName: "mainWindow"
    minimumWidth: 900
    minimumHeight: 600
    width: 1232
    height: 770
    color: Style.current.background
    title: {
        // Set application settings
        //% "Status Desktop"
        Qt.application.name = qsTrId("status-desktop")
        Qt.application.organization = "Status"
        Qt.application.domain = "status.im"
        return Qt.application.name
    }
    visible: true

    //! Workaround for custom QQuickWindow
    Connections {
        target: applicationWindow
        onClosing: {
            /*if (loader.sourceComponent == login) {
                applicationWindow.visible = false
                close.accepted = false
            }
            else if (loader.sourceComponent == app) {
                if (loader.item.appSettings.quitOnClose) {
                    close.accepted = true
                } else {
                    applicationWindow.visible = false
                    close.accepted = false
                }
            }*/
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
        Style.changeTheme(globalSettings.theme, systemPalette.isCurrentSystemThemeDark())
    }

    Component.onCompleted: {
        Style.changeTheme(globalSettings.theme, systemPalette.isCurrentSystemThemeDark())
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

   
    Loader {
        id: loader
        anchors.fill: parent
        property var appSettings
    }

    MacTrafficLights {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 13

        visible: Qt.platform.os === "osx" && !applicationWindow.isFullScreen

        onClose: {
            if (loader.sourceComponent == login) {
                Qt.quit();
            }
            else if (loader.sourceComponent == app) {
                if (loader.item.appSettings.quitOnClose) {
                    Qt.quit();
                } else {
                    applicationWindow.visible = false;
                }
            }
        }

        onMinimised: {
            applicationWindow.showMinimized()
        }

        onMaximized: {
            applicationWindow.toggleFullScreen()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
