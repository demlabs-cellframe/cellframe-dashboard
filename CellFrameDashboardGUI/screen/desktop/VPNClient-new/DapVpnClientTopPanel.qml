import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

DapTopPanel {

    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle
    color: currTheme.backgroundPanel

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 30*pt
        anchors.rightMargin: 30*pt

        Text
        {
            color: currTheme.textColorGray
            font: mainFont.dapFont.regular16
            text: qsTr("Time Connected:")
        }

        Text
        {
            Layout.fillWidth: true
            color: currTheme.textColor
            font: mainFont.dapFont.medium16
            text: "1d 16h 34m 18s"
        }

        DapButton
        {
            width: 22 * pt
            height: 24 * pt

            activeFrame: false
            heightImageButton: 24 * pt
            widthImageButton: 22 * pt

            normalImageButton: "qrc:/screen/desktop/VPNClient-new/Images/page.png"

            hoverImageButton:  "qrc:/screen/desktop/VPNClient-new/Images/page-hov.png"
            onClicked: vpnClientNavigator.openVpnReceipts()
        }
    }

}
