import QtQuick 2.9
import "../Certificates/parts/"

Item {
    property alias text:orderText.text
//    property alias activeButton:activeBtn

    property bool activeBtn:false
    property alias info_text : infoText

    width: root.width
    height: 40 * pt

    Text {
        id: orderText
        x: 14 * pt
        width: 612 * pt
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
        color: currTheme.textColor
        elide: Text.ElideRight
        maximumLineCount: 1


    }

    MouseArea{
        id: delegateClicked
        width: parent.width
        height: parent.height
        hoverEnabled: true
        onClicked: {
            if(activeBtn)
                console.log(orderText.text + " clicked")
        }

        onEntered:
        {
            if(activeBtn){
                orderText.color = currTheme.buttonColorNormal
                infoText.color = currTheme.buttonColorNormal
            }
        }

        onExited:
        {
            if(activeBtn)
            {
                orderText.color = currTheme.textColor
                infoText.color = currTheme.textColor
            }
        }
    }


    Text {
        id: infoText
        text: qsTr("0")
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: activeBtn? 50 * pt : 10 * pt
        color: currTheme.textColor
        font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
        verticalAlignment: Text.AlignVCenter
    }

    ToolButton {
        id: infoButton
        anchors {
            left: orderText.right
            right: parent.right
        }
        height: parent.height
        visible: activeBtn? true : false

        image.anchors {
            right: infoButton.right
            rightMargin: 14 * pt
        }
        image.source: "qrc:/resources/icons/arrow-right_icon.svg"
        image.width: 30 * pt
        image.height: 30 * pt

        onClicked: {
            if(activeBtn)
                console.log(orderText.text + " clicked")
        }
    }

    Rectangle {
        id: bottomLine
        x: orderText.x
        y: parent.height
        width: 648 * pt
        height: 1 * pt
        color: currTheme.backgroundMainScreen
    }
}
