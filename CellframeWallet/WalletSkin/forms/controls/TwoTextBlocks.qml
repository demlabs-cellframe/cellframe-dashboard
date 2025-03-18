import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "qrc:/widgets"

RowLayout {
    property alias label: labelItem.text
    property alias text: textItem.fullText
    property alias labelVisible: labelItem.visible
    property alias textColor: textItem.textColor
    property var textFont: mainFont.dapFont.regular13

    spacing: 3
    Text
    {
        id: labelItem
        font: textFont
        color: currTheme.gray
        Layout.preferredWidth: implicitWidth
    }

    DapBigText
    {
        id: textItem
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.rightMargin: 16
        textFont: parent.textFont
        textColor: currTheme.gray
//        outSymbols: 30

//        fullNumber: "0"
    }

//    Text
//    {
//        id: textItem
//        Layout.fillWidth: true
//        font: textFont
//        color: currTheme.textColorGray
//        elide: Text.ElideMiddle

//        ToolTip
//        {
//            id:toolTip
//            visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
//            text: parent.text
//            scale: mainWindow.scale

//            contentItem: Text {
//                    text: toolTip.text
//                    font: mainFont.dapFont.regular14
//                    color: currTheme.textColor
//                }
//            background: Rectangle{color:currTheme.backgroundPanel}
//        }
//        MouseArea
//        {
//            id:area
//            anchors.fill: parent
//            hoverEnabled: true
//        }
//    }
//    Item {
//        Layout.fillWidth: true
//    }
}
