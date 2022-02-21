import QtQuick 2.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
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
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium28
            }

            Text
            {
                anchors.top: textMessage.bottom
                anchors.topMargin:  24 * pt
                anchors.leftMargin: 43 * pt
                anchors.rightMargin: 32 * pt

                id: textMessageBottom
                text: qsTr("Now you can manage your\nwallets in Settings")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: currTheme.placeHolderTextColor
                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
            }

            DapButton
            {
                id: buttonDone
                height: 36 * pt
                width: 132 * pt
                anchors.top: textMessageBottom.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin:  153 * pt
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            }
        }
}
