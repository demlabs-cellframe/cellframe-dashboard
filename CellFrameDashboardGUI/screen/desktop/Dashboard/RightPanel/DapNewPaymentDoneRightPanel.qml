import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        console.log("dapButtonSend.onClicked")

        dapServiceController.requestToService("DapGetWalletsInfoCommand");

        nextActivated("transaction done")
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }

    Component.onCompleted:
    {
        dapDashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Successfully!")
    }
}
