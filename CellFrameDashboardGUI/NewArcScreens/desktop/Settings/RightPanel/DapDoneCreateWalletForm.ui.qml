import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"
import "../../../"

Page
{
    property alias dapButtonDone: buttonDone

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                font: _dapQuicksandFonts.dapFont.medium28
            }

            Text
            {
                anchors.top: textMessage.bottom
                anchors.topMargin:  24 * pt
                anchors.horizontalCenter: parent.horizontalCenter

                id: textMessageBottom
                text: qsTr("Now you can manage your\nwallets in Settings")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: currTheme.placeHolderTextColor
                font: _dapQuicksandFonts.dapFont.medium18
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
                fontButton: _dapQuicksandFonts.dapFont.medium14
            }
        }
    }
}
