import QtQuick 2.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapNextRightPanel: lastActionsWallet
    dapPreviousRightPanel: lastActionsWallet

    property alias dapButtonDone: buttonDone

    dapButtonClose.height: 16 * pt
    dapButtonClose.width: 16 * pt
    dapButtonClose.heightImageButton: 16 * pt
    dapButtonClose.widthImageButton: 16 * pt
    dapButtonClose.normalImageButton: "qrc:/res/icons/close_icon.png"
    dapButtonClose.hoverImageButton: "qrc:/res/icons/close_icon_hover.png"

    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt

            Item
            {
                id: itemButtonClose
                data: dapButtonClose
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
                anchors.bottom: textMessage.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
            }

            Text
            {
                id: textMessage
                text: qsTr("Wallet created\nsuccessfully")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin:  24 * pt
                anchors.bottom: rectangleCenter.top
                anchors.bottomMargin: 24 * pt
                color: "#070023"
                font.family: dapFontRobotoRegular.name
                font.pointSize: 16 * pt
            }

            Rectangle
            {
                id: rectangleCenter
                height: 118 * pt
                anchors.bottom: buttonDone.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
            }

            DapButton
            {
                id: buttonDone
                heightButton: 44 * pt
                widthButton: 130 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: rectangleBottom.top
                anchors.topMargin:  24 * pt
                anchors.bottomMargin: 24 * pt
                checkable: true
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton.pixelSize: 18 * pt
                colorTextButton: buttonDone.checked ? "#3E3853" : "#FFFFFF"
                colorBackgroundButton: "#3E3853"
            }

            Rectangle
            {
                id: rectangleBottom
                height: 189 * pt
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
            }

        }
}















/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
