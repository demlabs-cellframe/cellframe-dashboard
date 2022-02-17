import QtQuick 2.4
import QtQuick.Controls 2.0
import Demlabs 1.0
import "../../"
import "qrc:/widgets"
import "../SettingsWallet.js" as SettingsWallet


DapTopPanel
{
    property alias dapNewPayment: newPaymentButton
    property alias dapFrameTitle: frameTitleCreateWallet

    anchors.leftMargin: 4*pt
    radius: currTheme.radiusRectangle


    Item
    {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 34 * pt
        anchors.topMargin: 19 * pt
        anchors.bottomMargin: 18
        anchors.right: newPaymentButton.left
        anchors.rightMargin: 100 * pt
        Text
        {
            id: frameTitleCreateWallet
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            font:dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
            color: currTheme.textColor
//            text: qsTr("Name of my wallet")
        }
    }
    // Payment button
    DapButton
    {
        textButton: "Open transaction browser"
        anchors.right: newPaymentButton.left
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 38 * pt
        implicitWidth: 223 * pt
        fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
        horizontalAligmentText: Text.AlignHCenter
        onClicked:
        {
            Qt.openUrlExternally("https://test-explorer.cellframe.net/transaction");
        }
//        visible: frameTitleCreateWallet.text === "" ? false : true
    }
    // Payment button
    DapButton
    {
        id: newPaymentButton
        textButton: "Send"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 38 * pt
        implicitWidth: 163 * pt
        fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
        horizontalAligmentText: Text.AlignHCenter
        visible: frameTitleCreateWallet.text === "" ? false : true
//        visible: false
    }
}
