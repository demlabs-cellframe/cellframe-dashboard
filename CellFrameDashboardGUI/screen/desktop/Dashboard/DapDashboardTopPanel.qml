import QtQuick 2.4
import QtQuick.Controls 2.0
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets" as Widgets


Controls.DapTopPanel
{
    property alias dapNewPayment: newPaymentButton
    property alias dapFrameTitle: frameTitleCreateWallet


    Widgets.DapBigText
    {
        id: frameTitleCreateWallet
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: newPaymentButton.left
        anchors.rightMargin: 100
        height: 30
        anchors.verticalCenter: parent.verticalCenter

        textFont: mainFont.dapFont.medium18
    }


    // Payment button
    Widgets.DapButton
    {
        id: newPaymentButton
        textButton: "Send"
        anchors.right: parent.right
        anchors.rightMargin: 24

        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 36
        implicitWidth: 164
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter
        visible: frameTitleCreateWallet.text === "" ? false : true
//        visible: false
    }
}
