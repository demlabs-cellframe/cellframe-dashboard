import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/widgets"

DapAbstractMenuTabWidgetForm
{
    ///@detalis Width of the main menu bar item.
    property int widthItemMenu: dapMenuWidget.width
    ///@detalis Height of the main menu bar item.
    property int heightItemMenu: 52 * pt
    ///@detalis Width of the main menu bar item icon.
    property int widthIconItemMenu: 16 * pt
    ///@detalis Height of the main menu bar item icon.
    property int heightIconItemMenu: 16 * pt
    ///@detalis Сolor of the main menu bar item in normal condition.
    property string normalColorItemMenu: "transparent"
    ///@detalis Сolor of the main menu bar item in the selected state.
    property string selectColorItemMenu: "#D51F5D"
//    property string normalFont: dapMainFonts.dapFont.dapFontRobotoLightCustom
//    property string selectedFont: dapMainFonts.dapFont.dapFontRobotoRegularCustom
    property string normalFont: _dapQuicksandFonts.dapFont.lightCustom
    property string selectedFont: _dapQuicksandFonts.dapFont.regularCustom

    // Widget of the main menu bar item
    Component
    {
        id: itemMenuTabDelegate

        Item
        {
            id: frameItemMenu

            property bool isPushed: dapMenuWidget.currentIndex === index

            width: widthItemMenu
//            height: heightItemMenu
            height: showTab ? heightItemMenu : 0
//            color: normalColorItemMenu

            visible: showTab

            DapImageLoader{
                id:menuItemImg
                innerWidth: widthItemMenu
                innerHeight: heightItemMenu
                source: "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"

                anchors.left: parent.left
                anchors.rightMargin: 10 * pt
                anchors.verticalCenter: frameItemMenu.verticalCenter
                anchors.right: parent.right
                visible: false
            }


            DapImageLoader{
                id:iconItem
                innerWidth: widthIconItemMenu
                innerHeight: heightIconItemMenu
                source: normalIcon

                anchors.left: parent.left
                anchors.leftMargin: 26 * pt
                anchors.verticalCenter: parent.verticalCenter
            }

            Text
            {
                id: textItem
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconItem.right
                anchors.leftMargin: 16 * pt
                font.family: normalFont
                font.pixelSize: 13 * pt
                color: "#FFFFFF"
                text: name
            }

            MouseArea
            {
                id: handler
                anchors.fill: parent
                hoverEnabled: true

                onEntered:
                {
                    if(!frameItemMenu.isPushed)
                    {
                        iconItem.source = hoverIcon;
                        textItem.font.family = selectedFont;
                        menuItemImg.visible = true
                        menuItemImg.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_hover.png"
                    }
                }

                onExited:
                {
                    if(!frameItemMenu.isPushed)
                    {
                        iconItem.source = normalIcon
                        textItem.font.family = normalFont;
                        menuItemImg.visible = false
                        menuItemImg.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
                    }
                }

                onClicked:
                {
                    dapMenuWidget.currentIndex = index;
                    pathScreen = page;
                    menuItemImg.visible = true
                    menuItemImg.source = "qrc:/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
                }
            }

            onIsPushedChanged:
            {
//                frameItemMenu.color = (isPushed ?  selectColorItemMenu : normalColorItemMenu);
                iconItem.source = isPushed ? model.hoverIcon : model.normalIcon;
                textItem.font.family = (isPushed ? selectedFont : normalFont);
                menuItemImg.visible = isPushed ? true : false
            }
        }
    }
}
