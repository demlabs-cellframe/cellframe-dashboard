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
    width: 17 * pt
    height: 18 * pt

    signal copyClicked()

    Image
    {
        id:networkAddressCopyButtonImage
        width: parent.width
        height: parent.height
        source: "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            popup.opacity = 1
            popup.open()
            copyClicked()
            delay(1000,function() {
                popup.opacity = 0;
            })
        }
    }

    Popup
    {
        id: popup
        width: 140 * pt
        height: 40 * pt

        parent: root.parent
        x: root.x + root.width + 5 * pt
        y: root.y + root.height * 0.5 - height * 0.5

        closePolicy: Popup.NoAutoClose

        background: Rectangle
        {
            border.width: 1 * pt
            border.color: currTheme.hilightColorComboBox
            radius: 16 * pt
            color: currTheme.backgroundElements
        }

        Text {
            id: dapContentTitle
            font: mainFont.dapFont.medium12
            color: currTheme.textColor

            y: parent.height * 0.5 - height * 0.5
            x: 2 * pt
            text: "Address copied"
        }

        Image
        {
            width: 20 * pt
            height: 20 * pt
            y: parent.height * 0.5 - height * 0.5
            x: parent.width - width - 2 * pt
            source: "qrc:/resources/icons/" + pathTheme + "/check_icon.png"
        }
        onOpacityChanged: if (opacity == 0)
                              popup.close()
        Behavior on opacity {
            NumberAnimation {
                duration: 300
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
}
