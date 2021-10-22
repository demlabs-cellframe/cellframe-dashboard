import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    /// @param dapButtonSend Send button.
    property alias dapButtonSend: buttonSend

    dapNextRightPanel: lastActionsWallet
    dapPreviousRightPanel: lastActionsWallet

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
                text: qsTr("New payment")
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                color: currTheme.textColor
            }
        }
    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            color: "transparent"

            Rectangle
            {
                id: rectangleTop
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 156 * pt
                color: "transparent"
            }

            Text
            {
                id: textMessage
                text: qsTr("Placed to mempool")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectangleTop.bottom
                anchors.topMargin:  24 * pt
                color: "#070023"
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular28
            }

            Rectangle
            {
                id: rectangleCenter
                height: 48 * pt
                anchors.top: textMessage.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
            }

            Text
            {
                id: textStatus
                text: qsTr("Status")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectangleCenter.bottom
                color: "#757184"
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular22
            }

            Text
            {
                id: textStatusMessage
                text: qsTr("Pending")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textStatus.bottom
                anchors.topMargin: 8 * pt
                color: "#070023"
                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular28
            }

            Rectangle
            {
                id: rectangleTopButton
                height: 64 * pt
                anchors.top: textStatusMessage.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
            }

            // Button "Send"
            DapButton
            {
                id: buttonSend
                height: 44 * pt
                width: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectangleTopButton.bottom
                anchors.topMargin: 24 * pt
                textButton: qsTr("Send")
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#3E3853"
                colorButtonTextNormal: "#FFFFFF"
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
            }

            Rectangle
            {
                id: rectangleBottomButton
                height: 190 * pt
                anchors.top: buttonSend.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
}
