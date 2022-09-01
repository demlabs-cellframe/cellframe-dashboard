import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12
import "qrc:/widgets"

Item
{
    id: buttonDelegate

    width: 180 
    height: showTab ? 52  : 0
    visible: showTab

    property bool isPushed: mainButtonsList.currentIndex === index

    signal pushPage(var pageUrl)
    property string pathScreen

    Image {
        id: backgroundImage
        mipmap: true
        anchors.fill: parent
        anchors.rightMargin: 10
        opacity: isPushed? 1: 0
        source: "qrc:/Resources/" + pathTheme + "/icons/other/bg-menuitem_active.png"

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 26

        Item {
            id: ico
            width: 16 
            height: 16 
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            DapImageLoader {
                innerWidth: parent.width
                innerHeight: parent.height
                source: "qrc:/Resources/" + pathTheme + "/icons/navigation/" + bttnIco
            }
        }

        Text {
            id: buttonText
            anchors.left: ico.right
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: name
            elide: Text.ElideMiddle
            color: currTheme.textColor
            font:mainFont.dapFont.regular13
        }
    }
    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Connections
    {
        target: dapMainWindow
        onCheckWebRequest:{
            if(page === settingsScreenPath)
            {
                if(!buttonDelegate.isPushed)
                {
                    mainButtonsList.currentIndex = index;
                    backgroundImage.source = "qrc:/Resources/" + pathTheme + "/icons/other/bg-menuitem_active.png"
                    pushPage(page)
                }

                delay(400,function() {
                    openRequests()
                })

            }
        }
    }

    MouseArea
    {
        id: handler
        anchors.fill: parent
        hoverEnabled: true

        onEntered:
        {
            if(!buttonDelegate.isPushed)
            {
                delay(300,function() {
                    if(handler.containsMouse && !buttonDelegate.isPushed)
                    {
                        backgroundImage.opacity = 1
                        backgroundImage.source = "qrc:/Resources/" + pathTheme + "/icons/other/bg-menuitem_hover.png"
                    }
                })
            }
        }

        onExited:
        {
            if(!buttonDelegate.isPushed)
            {
                backgroundImage.opacity = 0
            }
        }

        onClicked:
        {
            mainButtonsList.currentIndex = index;
            backgroundImage.source = "qrc:/Resources/" + pathTheme + "/icons/other/bg-menuitem_active.png"
            pushPage(page)
        }
    }
    onIsPushedChanged:
    {
        backgroundImage.opacity = isPushed ? 1 : 0
    }
}
