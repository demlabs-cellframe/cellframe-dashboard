import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    property bool isShow: false
//    property var target
//    property int heightDelegate
    property string text

    signal buttonClicked()

    height: 20

    Text{
        id: textElement
        anchors.centerIn: parent
        height: 20
        font: mainFont.dapFont.medium14
        color: currTheme.lime
        text: parent.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    DapImageRender{
        anchors.left: textElement.right
        anchors.leftMargin: 8
        source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_chevronDown.svg"

        rotation: isShow ? 180 : 0

        Behavior on rotation{
            NumberAnimation{
                duration: 200
            }
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            console.log("onClicked", "parent.isShow", parent.isShow)

            if(parent.isShow)
                isShow = false
            else
                isShow = true

            buttonClicked()

//            target.height = getHeight(isShow, heightDelegate, target.contentHeight)
        }
    }
}
