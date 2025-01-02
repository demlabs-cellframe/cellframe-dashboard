import QtQuick 2.9
import "../../Certificates/parts/"

Item {
    property alias text:orderText.text

    property bool activeBtn: false
    property alias info_text: infoText

    width: root.width
    height: 40 
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.right: parent.right
    anchors.rightMargin: 10

    Text {
        id: orderText
        x: 14 
        width: 612 
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        font: mainFont.dapFont.regular16
        color: currTheme.white
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
                orderText.color = currTheme.lightGreen
                infoText.color = currTheme.lightGreen
                img.source = "qrc:/Resources/"+ pathTheme +"/icons/other/back_hover.svg"
            }
        }

        onExited:
        {
            if(activeBtn)
            {
                orderText.color = currTheme.white
                infoText.color = currTheme.white
                img.source = "qrc:/Resources/"+ pathTheme +"/icons/other/back.svg"
            }
        }
    }


    Text {
        id: infoText
        text: "0"
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: activeBtn? 50  : 10 
        color: currTheme.white
        font: mainFont.dapFont.regular16
        verticalAlignment: Text.AlignVCenter
    }

    Item{
//        property bool activeBtn: true
        id: infoButton
        anchors {
            left: orderText.right
            right: parent.right
        }
        height: parent.height
        visible: activeBtn? true : false

        Image{
            id: img
            anchors {
                right: infoButton.right
                rightMargin: 14 
                verticalCenter: parent.verticalCenter
            }
            source: "qrc:/Resources/"+ pathTheme +"/icons/other/back.svg"
            width: 20 
            height: 20 
            mirror: true
        }
    }

    Rectangle {
        id: bottomLine
        x: orderText.x
        y: parent.height
        width: 648 
        height: 1 
        color: currTheme.mainBackground
    }
}
