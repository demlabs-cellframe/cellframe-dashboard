import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ItemDelegate
{
    id: buttonDelegate

    width: 180 
    height: 40 

    property bool isPushed: mainButtonsList.currentIndex === index

    background: Rectangle {
        color: currTheme.secondaryBackground
        radius: 20
        anchors.leftMargin: -10
    }

    DapImageRender {
        id: backgroundImage
        width: buttonDelegate.width
        height: buttonDelegate.height
        visible: false
        source: "qrc:/walletSkin/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        Item {
            id: ico
            width: 18 
            height: 18 
            Layout.alignment: Qt.AlignLeft
            DapImageRender {
                anchors.fill: parent
                source: "qrc:/walletSkin/resources/icons/" + pathTheme + "/" + modelData.bttnIco
            }
        }

        Text {
            id: buttonText
            anchors.left: ico.right
            anchors.leftMargin: 15
            text: modelData.name
            color: currTheme.white
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
                backgroundImage.source = "qrc:/walletSkin/resources/icons/" + pathTheme + "/bg-menuitem_hover.png"
            }
        }

        onExited:
        {
            if(!buttonDelegate.isPushed)
            {
                backgroundImage.visible = false
                backgroundImage.source = "qrc:/walletSkin/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
            }
        }

        onClicked:
        {
            mainButtonsList.currentIndex = index;
            backgroundImage.visible = true
            backgroundImage.source = "qrc:/walletSkin/resources/icons/" + pathTheme + "/bg-menuitem_active.png"
        }
    }
    onIsPushedChanged:
    {
        backgroundImage.visible = isPushed ? true : false
    }
}
