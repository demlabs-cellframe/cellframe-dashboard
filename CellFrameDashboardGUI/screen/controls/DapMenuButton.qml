import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    id: buttonDelegate

    width: 173 * pt
    height: modelData.showTab ? 52 * pt : 0
    visible: modelData.showTab

    property bool isPushed: mainButtonsList.currentIndex === index

//    background: Item {
////        color: currTheme.backgroundPanel
////        radius: 16
//        anchors.leftMargin: -3
//    }

    DapImageLoader {
        id: backgroundImage
        innerWidth: buttonDelegate.width
        innerHeight: buttonDelegate.height
        visible: false
        source: "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 26
        spacing: 0
        Item {
            id: ico
            width: 16 * pt
            height: 16 * pt
            Layout.alignment: Qt.AlignLeft
            DapImageLoader {
                innerWidth: parent.width
                innerHeight: parent.height
                source: "qrc:/resources/icons/" + pathTheme + "/" + modelData.bttnIco
            }
        }

        Text {
            id: buttonText
//            Layout.alignment: Qt.AlignLeft
//            Layout.leftMargin: 16
            anchors.left: ico.right
            anchors.leftMargin: 16
            text: modelData.name
            color: currTheme.textColor
            font:_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular13
        }
    }

    MouseArea
    {
        id: handler
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered:
        {
            if(!buttonDelegate.isPushed)
            {
                backgroundImage.visible = true
                backgroundImage.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_hover.png"
            }
        }

        onExited:
        {
            if(!buttonDelegate.isPushed)
            {
                backgroundImage.visible = false
                backgroundImage.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
            }
        }

        onClicked:
        {
            mainButtonsList.currentIndex = index;
            backgroundImage.visible = true
            backgroundImage.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
        }
    }
    onIsPushedChanged:
    {
        backgroundImage.visible = isPushed ? true : false
    }

    Connections
    {
        target:dapMainPage
        onTabUpdate:
        {
            console.log("TAG = ", tag)
            console.log("MODEL TAG = ", modelData.tag)
            if(tag === modelData.tag)
            {
                buttonDelegate.visible = status
                if(status)
                    buttonDelegate.height = 52
                else
                    buttonDelegate.height = 0
            }
        }
    }
}
