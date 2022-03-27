import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "../../controls" as Controls
import "qrc:/widgets" as Widgets

Controls.DapTopPanel {
    property alias dapNewPayment: newPaymentButton
    property alias dapFrameTitle: frameTitleCreateWallet

    // Wallet selection combo box
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
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
            color: currTheme.textColor
//            text: qsTr("Name of my wallet")
        }
    }
    // Payment button
    Widgets.DapButton
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
        fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
        horizontalAligmentText: Text.AlignHCenter
        visible: frameTitleCreateWallet.text === "" ? false : true
//        visible: false
    }
}
