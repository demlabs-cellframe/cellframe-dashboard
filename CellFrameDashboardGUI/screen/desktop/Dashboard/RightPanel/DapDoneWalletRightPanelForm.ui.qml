import QtQuick 2.4
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapHeaderData:
        Row
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.rightMargin: 16 * pt
            anchors.topMargin: 12 * pt
            anchors.bottomMargin: 12 * pt
            DapButton
            {
                id: buttonClose
                height: 16 * pt
                width: 16 * pt
                heightImageButton: height
                widthImageButton: width
                colorBackgroundNormal: "#F8F7FA"
                colorBackgroundHover: "#F8F7FA"
                normalImageButton: "qrc:/res/icons/close_icon.png"
                hoverImageButton: "qrc:/res/icons/close_icon_hover.png"
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
                font.family: DapMainApplicationWindow.dapFontRobotoRegular.name
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
                existenceImage: false
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontSizeButton: 18 * pt
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
