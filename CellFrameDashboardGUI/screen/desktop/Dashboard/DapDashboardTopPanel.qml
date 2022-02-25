import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "qrc:/widgets"
import "../../Logic/Logic.js" as Logic

Page {
    property alias dapNewPayment: newPaymentButton
    property alias dapFrameTitle: frameTitleCreateWallet

    Text
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        Layout.leftMargin: 20
    }

    // Wallet selection combo box
    RowLayout
    {
        id: frameComboBoxWallet

        anchors.left: textHeaderWallet.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 148 * pt

//        DapComboBoxNew {
//            id: comboboxWallet
//            model: walletsNames
//        }

        Text
        {
            id: frameTitleCreateWallet
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            font:_dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
            color: currTheme.textColor
//            text: qsTr("Name of my wallet")
        }
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
        fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
        horizontalAligmentText: Text.AlignHCenter
        visible: frameTitleCreateWallet.text === "" ? false : true
    }
}
