import QtQuick 2.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapNextRightPanel: lastActionsWallet
    dapPreviousRightPanel: lastActionsWallet

    property alias dapButtonDone: buttonDone

    dapContentItemData:
        Item
        {
            anchors.fill: parent

            Text
            {
                id: textMessage
                text: qsTr("Wallet created\nsuccessfully")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin:  180 * pt
                anchors.leftMargin: 47 * pt
                anchors.rightMargin: 49 * pt
                color: currTheme.textColor
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular28
            }

            DapButton
            {
                id: buttonDone
                height: 36 * pt
                width: 132 * pt
                anchors.top: textMessage.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin:  242 * pt
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            }
        }
}















/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/