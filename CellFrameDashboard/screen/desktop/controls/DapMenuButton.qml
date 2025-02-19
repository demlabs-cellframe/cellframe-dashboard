import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12
import "qrc:/widgets"


Item
{
    property alias backgroundImage: backgroundImage
    id: buttonDelegate

    width: parent.width
    height: showTab ? 52  : 0
    visible: showTab

    property bool isPushed: mainButtonsList.currentIndex === index

    signal pushPage(var pageUrl)
    property string pathScreen


    Image {
        id: backgroundImage
        mipmap: true
        height: parent.height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: mainRowLayout.canCompactLeftMenu ? parent.width == mainRowLayout.expandWidth ? 10 : 4 : 10
        opacity: isPushed? 1: 0
        source: "qrc:/Resources/" + pathTheme + "/icons/other/bg-menuitem_active.png"
        sourceSize: Qt.size(170, parent.height + 2)

        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: 24

        Image {
            id: ico
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            mipmap: true
            source: "qrc:/Resources/" + pathTheme + "/icons/navigation/" + bttnIco
        }

        Text {
            id: buttonText
            anchors.left: ico.right
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            text: name
            color: currTheme.white
            font:mainFont.dapFont.regular13
            opacity: mainRowLayout.isCompact ? 0.0 : 1.0

            Behavior on opacity { NumberAnimation { duration: 150 } }

            DapCustomToolTip{
                visible: handler.containsMouse ?  buttonText.implicitWidth > buttonText.width ? true : false : false
                contentText: buttonText.text
                textFont: buttonText.font
                onVisibleChanged: updatePos()
            }
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
        function onCheckWebRequest() {
            console.log(pathScreen, settingsScreenPath)
            if(pathScreen === settingsScreenPath)
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

            if(mainRowLayout.canCompactLeftMenu) mainRowLayout.expandOrCompress(true)
        }

        onExited:
        {
            if(!buttonDelegate.isPushed)
            {
                backgroundImage.opacity = 0
            }

            if(mainRowLayout.canCompactLeftMenu) mainRowLayout.expandOrCompress(false)
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
