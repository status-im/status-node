import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13
import "../../imports"
import "../../shared"

Item {
    property string name
    property string description

    id: root
    
    
    anchors.left: parent.left
    anchors.leftMargin: -Style.current.padding
    anchors.right: parent.right
    anchors.rightMargin: Style.current.padding


    implicitHeight: 52

    StyledText {
        id: name
        text: root.name
        font.pixelSize: 15
        anchors.left: parent.left
        anchors.leftMargin: Style.current.padding
        anchors.verticalCenter: parent.verticalCenter
    }

    StyledText {
        id: description
        visible: !!root.description
        text: root.description
        elide: Text.ElideRight
        font.pixelSize: 15
        horizontalAlignment: Text.AlignRight
        color: Style.current.secondaryText
        anchors.left: name.right
        anchors.leftMargin: Style.current.padding
        anchors.right: parent.right
        anchors.rightMargin: Style.current.padding
        anchors.verticalCenter: name.verticalCenter

        CopyToClipBoardButton {
            id: copyToClipboardBtn
            textToCopy: root.description
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: Style.current.smallPadding
        }
    }
}

