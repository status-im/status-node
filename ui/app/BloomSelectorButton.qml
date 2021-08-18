import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../imports"
import "../shared"
import "../shared/status"


Rectangle {
    property var buttonGroup
    //% "TODO"
    property string btnText: qsTrId("todo")
    property bool hovered: false
    property bool checkedByDefault: false
    property bool enabled: true
    
    signal checked()
    signal toggled(bool checked)

    function click(){
        radioBtn.toggle()
    }

    id: root
    border.color: hovered || radioBtn.checked ? (enabled ? Style.current.primary : Style.current.border ): Style.current.border
    border.width: 1
    color: Style.current.transparent
    width: 150
    height: 100
    clip: true
    radius: Style.current.radius

    StatusRadioButton {
        id: radioBtn
        ButtonGroup.group: buttonGroup
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 14
        enabled: root.enabled
        checked: root.checkedByDefault
        onCheckedChanged: {
            if (checked) {
                root.checked()
            }
        }
    }

    StyledText {
        id: txt
        text: btnText
        font.pixelSize: 15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: radioBtn.bottom
        anchors.topMargin: 6
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: {
            if (!root.enabled) return;
            radioBtn.toggle()
            root.toggled(radioBtn.checked)
        }
    }
}
