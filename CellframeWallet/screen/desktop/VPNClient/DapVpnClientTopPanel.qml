import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../controls"

DapTopPanel {

    property bool _isReceiptsOpen

//    anchors.leftMargin: 24 * pt
//    radius: currTheme.frameRadius
//    color: currTheme.backgroundPanel

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 24 * pt
        anchors.rightMargin: 24 * pt

        Text
        {
            color: currTheme.textColorGray
            font: mainFont.dapFont.regular16
            text: qsTr("Time connected:")
        }

        Text
        {
            Layout.fillWidth: true
            color: currTheme.textColor
            font: mainFont.dapFont.regular16
            text: qsTr("1d 16h 34m 18s")
        }

        HeaderButtonForRightPanels
        {
            Layout.alignment: Qt.AlignRight

            height: 24 * pt
            width: 24 * pt
            heightImage: 24 * pt
            widthImage: 24 * pt

            normalImage: _isReceiptsOpen ? "qrc:/Resources/" + pathTheme + "/icons/other/receipt_hover.svg" : "qrc:/Resources/" + pathTheme + "/icons/other/receipt_normal.svg"
            hoverImage:  "qrc:/Resources/" + pathTheme + "/icons/other/receipt_hover.svg"
            onClicked: vpnClientNavigator.openVpnReceipts()
        }
    }

}
