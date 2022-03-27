import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen {

    id: dapVpnClientScreen
    anchors
    {
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 44 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt
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
        border.width: 1 * pt

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
                border.width: 1 * pt

                Text {
                    id:topText
                    anchors.top: parent.top
                    anchors.left: parent.left
                    text: qsTr("Conntected to:")
                    color: currTheme.textColorGray
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                }

                Text {
                    id:connectToText
                    anchors.top: topText.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 10 * pt
                    text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
                    color: currTheme.textColor
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                }

                DapButton
                {
                    textButton: "Disconnect"
                    anchors.right: parent.right
                    anchors.top: parent.top
//                    anchors.left: parent.verticalCenter
//                    anchors.leftMargin: 472 * pt
                    anchors.topMargin: 17 * pt
                    implicitHeight: 36 * pt
                    implicitWidth: 165 * pt
                    fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                    horizontalAligmentText: Text.AlignHCenter
                }
            }

            Rectangle
            {
                id: frameMidElements
                Layout.fillWidth: true
                Layout.topMargin: 50 * pt

                height: 238 * pt

                color:"transparent"
                border.color: "gray"
                border.width: 1 * pt

                RowLayout
                {
                    anchors.fill: parent
                    spacing: 26 * pt

                    Rectangle{
//                        implicitWidth: 308 * pt
//                        implicitHeight: 238 * pt
                        radius: 16*pt
                        color: currTheme.backgroundElements
                    }

                    Rectangle{
//                        implicitWidth: 308 * pt
//                        implicitHeight: 238 * pt
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
