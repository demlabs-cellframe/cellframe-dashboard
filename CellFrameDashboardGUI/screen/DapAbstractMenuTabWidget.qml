import QtQuick 2.4

DapAbstractMenuTabWidgetForm
{
    ///@detalis Width of the main menu bar item.
    property int widthItemMenu: dapMenuWidget.width
    ///@detalis Height of the main menu bar item.
    property int heightItemMenu: 60 * pt
    ///@detalis Width of the main menu bar item icon.
    property int widthIconItemMenu: 18 * pt
    ///@detalis Height of the main menu bar item icon.
    property int heightIconItemMenu: 18 * pt
    ///@detalis Сolor of the main menu bar item in normal condition.
    property string normalColorItemMenu: "transparent"
    ///@detalis Сolor of the main menu bar item in the selected state.
    property string selectColorItemMenu: "#D51F5D"
//    property string normalFont: dapMainFonts.dapMainFontTheme.dapFontRobotoLightCustom
//    property string selectedFont: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
    property string normalFont: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandLightCustom
    property string selectedFont: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegularCustom

    // Widget of the main menu bar item
    Component
    {
        id: itemMenuTabDelegate

        Rectangle
        {
            id: frameItemMenu

            property bool isPushed: dapMenuWidget.currentIndex === index

            width: widthItemMenu
            height: heightItemMenu
            color: normalColorItemMenu

            Image
            {
                id: iconItem
                anchors.left: parent.left
                anchors.leftMargin: 24 * pt
                anchors.verticalCenter: parent.verticalCenter
                height: heightIconItemMenu
                width: widthIconItemMenu
                source: normalIcon
            }

            Text
            {
                id: textItem
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: iconItem.right
                anchors.leftMargin: 18 * pt
                font.family: normalFont
                font.pixelSize: 16 * pt
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
                    }
                }

                onExited:
                {
                    if(!frameItemMenu.isPushed)
                    {
                        iconItem.source = normalIcon
                        textItem.font.family = normalFont;
                    }
                }

                onClicked:
                {
                    dapMenuWidget.currentIndex = index;
                    pathScreen = page;
                }
            }

            onIsPushedChanged:
            {
                frameItemMenu.color = (isPushed ?  selectColorItemMenu : normalColorItemMenu);
                iconItem.source = isPushed ? model.hoverIcon : model.normalIcon;
                textItem.font.family = (isPushed ? selectedFont : normalFont);
            }
        }
    }
}
