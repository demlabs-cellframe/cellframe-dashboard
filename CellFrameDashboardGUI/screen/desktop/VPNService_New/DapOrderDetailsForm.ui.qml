import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../"

DapRightPanel {

//    property alias dapTextInputNameOrder: textInputNameOrder
//    property alias dapComboBoxRegion: comboBoxRegion
//    property alias dapComboBoxUnit: comboBoxUnit
//    property alias dapComboBoxPrice: comboBoxPrice
//    property alias dapButtonCreate: buttonCreate
    property alias dapOrderIndex: textTotalUsers


    dapNextRightPanel: earnedFundsOrder
    dapPreviousRightPanel: earnedFundsOrder

    width: 400 * pt

    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            spacing: 12 * pt

            Item
            {
                id: itemButtonClose
                data: dapButtonClose
                height: dapButtonClose.height
                width: dapButtonClose.width
            }

            Text
            {
                id: textHeader
                text: qsTr("Order details")
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                color: "#3E3853"
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
                anchors.topMargin: 8 * pt
                anchors.bottomMargin: 8 * pt
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textUsers
                    color: "#ffffff"
                    text: qsTr("Users")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameTotalUsers
                height: 68 * pt
                color: "transparent"
                anchors.top: frameUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 5 * pt
                DapOrderPanelButton
                {
                    id: textTotalUsers
                    text: qsTr("Total")
                    activeBtn: true
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 5 * pt
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameNowUsers
                height: 68 * pt
                color: "transparent"
                anchors.top: frameTotalUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 5 * pt
                DapOrderPanelButton
                {
                    id: textNowUsers
                    text: qsTr("Now")
                    activeBtn: false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 5 * pt
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameConnectionHistory
                anchors.top: frameNowUsers.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textRegion
                    color: "#ffffff"
                    text: qsTr("Connection history")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameLastConnection
                height: 68 * pt
                color: "transparent"
                anchors.top: frameConnectionHistory.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 5 * pt

                DapOrderPanelButton
                {
                    id: textLastConnection
                    text: qsTr("Last connection")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: true
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 5 * pt
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
                color: "#757184"
                height: 30 * pt
                Text
                {
                    id: textUnits
                    color: "#ffffff"
                    text: qsTr("Load")
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                }
            }
            Rectangle
            {
                id: frameAverageLoad
                height: 68 * pt
                color: "transparent"
                anchors.top: frameLoad.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 5 * pt

                DapOrderPanelButton
                {
                    id: textAverageLoad
                    text: qsTr("Average load")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: false
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 5 * pt
                    anchors.right: parent.right
                }
            }
            Rectangle
            {
                id: frameAverageReceipt
                height: 68 * pt
                color: "transparent"
                anchors.top: frameAverageLoad.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 5 * pt

                DapOrderPanelButton
                {
                    id: textAverageReceipt
                    text: qsTr("Average receipt")
                    anchors.verticalCenter: parent.verticalCenter
                    activeBtn: false
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    anchors.rightMargin: 5 * pt
                    anchors.right: parent.right
                }
            }

            Rectangle
            {
                id: frameBottom
                height: 124 * pt
                anchors.top: frameAverageReceipt.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
}
