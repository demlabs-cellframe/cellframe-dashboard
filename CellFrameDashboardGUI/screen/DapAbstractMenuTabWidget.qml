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
                font.family: dapFontRobotoLight.name
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
                        textItem.font.family = dapFontRobotoRegular.name;
                    }
                }

                onExited:
                {
                    if(!frameItemMenu.isPushed)
                    {
                        iconItem.source = normalIcon
                        textItem.font.family = dapFontRobotoLight.name;
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
                textItem.font.family = (isPushed ? dapFontRobotoRegular.name : dapFontRobotoLight.name);
            }
        }
    }
}
