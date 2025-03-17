import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQml 2.12

Item
{
    id: root
    width: 16
    height: 17

    signal copyClicked()

    Image
    {
        id:networkAddressCopyButtonImage
        width: parent.width
        height: parent.height
        mipmap: true
        source: mouseArea.containsMouse ? "qrc:/Resources/" + pathTheme + "/icons/other/copy_hover.svg":
                                          "qrc:/Resources/" + pathTheme + "/icons/other/copy.svg"
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked:
        {
//            popup.opacity = 0
//            popup.open()
//            popup.opacity = 1
            dapMainWindow.infoItem.showInfo(
                        0,0,
                        dapMainWindow.width*0.5,
                        8,
                        qsTr("Address copied"),
                        "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            copyClicked()
//            delay(1000,function() {
//                popup.opacity = 0;
//            })
        }
    }

//    Popup
//    {
//        id: popup
//        width: 140 
//        height: 40 
//        scale: mainWindow.scale

////        parent: root.parent

////        x: root.x + root.width + 5 
////        y: root.y + root.height * 0.5 - height * 0.5

//    //        parent: root
////        x: (parent.width - popup.width) / 2
////        y: -40

//        parent: dapMainWindow

//        x: parent.width/2 - width/2
//        y: 40

//        closePolicy: Popup.NoAutoClose

//        background: Rectangle
//        {
//            border.width: 1 
//            border.color: currTheme.lineSeparatorColor
//            radius: 16 
//            color: currTheme.backgroundElements
//        }

//        Text {
//            id: dapContentTitle
//            font: mainFont.dapFont.medium12
//            color: currTheme.textColor

//            y: parent.height * 0.5 - height * 0.5
//            x: 2 
//            text: "Address copied"
//        }

//        DapImageLoader
//        {
//            innerWidth: 20
//            innerHeight: 20
//            y: parent.height * 0.5 - height * 0.5
//            x: parent.width - width - 2 
////            mipmap: true
//            source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
//        }
//        onOpacityChanged: if (opacity == 0)
//                              popup.close()
//        Behavior on opacity {
//            NumberAnimation {
//                duration: 400
//            }
//        }
//    }



//    Timer {
//        id: timer
//    }

//    function delay(delayTime, cb) {
//        timer.interval = delayTime;
//        timer.repeat = false;
//        timer.triggered.connect(cb);
//        timer.start();
//    }
}
