import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
//import "../../"
import "../Parts"

DapRightPanel {

    dapButtonClose.onClicked:
    {
        dapRightPanel.pop()
    }
    property alias dapOrderIndex: textTotalUsers


    dapNextRightPanel: earnedFundsOrder
    dapPreviousRightPanel: earnedFundsOrder

//    width: 400 * pt

    dapHeaderData:
        Item
        {
            anchors.fill: parent
//            Layout.fillWidth: true
            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 9 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt
            }

            Text
            {
                id: textHeader
                text: qsTr("Order details")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: _dapQuicksandFonts.dapFont.bold14
                color: currTheme.textColor
            }
        }
    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"
            Rectangle
            {
                id:frameUsers
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
//                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textUsers
                    color: currTheme.textColor
                    text: qsTr("Users")
                    font: _dapQuicksandFonts.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }
            Rectangle
            {
                id: frameTotalUsers
                height: 41 * pt
                color: "transparent"
                anchors.top: frameUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                DapOrderPanelButton
                {
                    id: textTotalUsers
                    text: qsTr("Total")
                    activeBtn: true
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameNowUsers
                anchors.top: frameTotalUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                height: 41 * pt
                color: "transparent"
                DapOrderPanelButton
                {
                    id: textNowUsers
                    text: qsTr("Now")
                    activeBtn: false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameConnectionHistory
                anchors.top: frameNowUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textRegion
                    color: currTheme.textColor
                    text: qsTr("Connection history")
                    font: _dapQuicksandFonts.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }
            Rectangle
            {
                id: frameLastConnection
                anchors.top: frameConnectionHistory.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                height: 41 * pt
                color: "transparent"

                DapOrderPanelButton
                {
                    id: textLastConnection
                    text: qsTr("Last connection")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: true
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameLoad
                anchors.top: frameLastConnection.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: currTheme.backgroundMainScreen
                height: 30 * pt
                Text
                {
                    id: textUnits
                    color: currTheme.textColor
                    text: qsTr("Load")
                    font: _dapQuicksandFonts.dapFont.medium12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * pt
                    anchors.topMargin: 8
                    anchors.bottomMargin: 7
                }
            }
            Rectangle
            {
                id: frameAverageLoad
                anchors.top: frameLoad.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                height: 41 * pt
                color: "transparent"

                DapOrderPanelButton
                {
                    id: textAverageLoad
                    text: qsTr("Average load")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: false
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameAverageReceipt
                anchors.top: frameAverageLoad.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 29 * pt
                anchors.rightMargin: 35 * pt
                anchors.topMargin: 5 * pt
                height: 41 * pt
                color: "transparent"

                DapOrderPanelButton
                {
                    id: textAverageReceipt
                    text: qsTr("Average receipt")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: false
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
            }
        }
}
