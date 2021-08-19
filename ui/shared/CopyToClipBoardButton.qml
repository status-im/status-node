import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import "../imports"
import "../shared/status"

Rectangle {
    id: copyToClipboardButton
    height: 32
    width: 32
    radius: 8
    color: Style.current.transparent
    property var onClick: function() {}
    property string textToCopy: ""

    Image {
        width: 20
        height: 20
        sourceSize.width: width
        sourceSize.height: height
        source: "./img/copy-to-clipboard-icon.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ColorOverlay {
            anchors.fill: parent
            antialiasing: true
            source: parent
            color: Style.current.primary
        }
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            parent.color = Style.current.transparent
        }
        onEntered:{
            parent.color = Style.current.backgroundHover
        }
        onPressed: {
            parent.color = Style.current.grey2
        }
        onReleased: {
            parent.color = Style.current.backgroundHover
        }
        onClicked: {
            if (textToCopy) {
                nodeModel.copyToClipboard(textToCopy)
            }
            onClick()
        }
    }
}


