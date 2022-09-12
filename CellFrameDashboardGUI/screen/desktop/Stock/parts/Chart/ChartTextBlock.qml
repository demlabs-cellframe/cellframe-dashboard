import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

RowLayout {
    property alias label: labelItem.text
    property alias text: textItem.text
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.color
    property var textFont: mainFont.dapFont.regular13

    spacing: 3
    Text
    {
        id: labelItem
        font: textFont
        color: currTheme.textColorGray
    }
    Text
    {
        id: textItem
        Layout.fillWidth: true
        font: textFont
        color: currTheme.textColorGray
        elide: Text.ElideMiddle

        ToolTip
        {
            id:toolTip
            visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
            text: parent.text
            scale: mainWindow.scale

            contentItem: Text {
                    text: toolTip.text
                    font: mainFont.dapFont.regular14
                    color: currTheme.textColor
                }
            background: Rectangle{color:currTheme.backgroundPanel}
        }
        MouseArea
        {
            id:area
            anchors.fill: parent
            hoverEnabled: true
        }
    }
    Item {
        Layout.fillWidth: true
    }
}
