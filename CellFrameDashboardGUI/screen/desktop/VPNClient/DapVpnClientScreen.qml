import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"

Page {

    id: dapVpnClientScreen
    anchors
    {
        top: parent.top
        topMargin: 24 
        right: parent.right
        rightMargin: 44 
        left: parent.left
        leftMargin: 24 
        bottom: parent.bottom
        bottomMargin: 20 
    }

    Rectangle
    {
        id:vpnClientFrame

        anchors.fill: parent
        anchors.topMargin: 13*pt
        anchors.leftMargin: 21*pt
        anchors.rightMargin: 22*pt

        color:"transparent"
        border.color: "green"
        border.width: 1 

        ColumnLayout
        {
            anchors.fill: parent

            Rectangle
            {
                id: frameTopElements
                Layout.fillWidth: true

                height: connectToText.height + topText.height + 10*pt

                color:"transparent"
                border.color: "yellow"
                border.width: 1 

                Text {
                    id:topText
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: qsTr("Conntected to:")
                    color: currTheme.textColorGray
                    font: mainFont.dapFont.regular16
                }

                Text {
                    id:connectToText
                    anchors.top: topText.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 10 
                    text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium18
                }

                DapButton
                {
                    textButton: "Disconnect"
                    anchors.right: parent.right
                    anchors.top: parent.top
//                    anchors.left: parent.verticalCenter
//                    anchors.leftMargin: 472 
                    anchors.topMargin: 17 
                    implicitHeight: 36 
                    implicitWidth: 165 
                    fontButton: mainFont.dapFont.medium16
                    horizontalAligmentText: Text.AlignHCenter
                }
            }

            Rectangle
            {
                id: frameMidElements
                Layout.fillWidth: true
                Layout.topMargin: 50 

                height: 238 

                color:"transparent"
                border.color: "gray"
                border.width: 1 

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 26 

                    Rectangle{
//                        implicitWidth: 308 
//                        implicitHeight: 238 
                        radius: 16*pt
                        color: currTheme.backgroundElements
                    }

                    Rectangle{
//                        implicitWidth: 308 
//                        implicitHeight: 238 
                        radius: 16*pt
                        color: currTheme.backgroundElements
                    }
                }



            }
        }
    }




//        RowLayout
//        {
//            id:midPlace
//        }
//        Layout
//        {
//            id:bottomPlace
//        }
//    }

}
