import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        console.log("dapButtonSend.onClicked")

        dapServiceController.requestToService("DapGetWalletsInfoCommand");

        navigator.popPage()
    }

    Component.onCompleted:
    {
//        dapDashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Successfully!")

        if(commandResult.success)
        {
            dapStatusTransaction.text = qsTr("Pending")
            dapDashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Successfully!")
        }
        else
        {
            dapStatusTransaction.text = qsTr("Error")
            dapDashboardScreen.dapFrameTitleCreateWallet.text = qsTr("Unsuccessfully!")
        }
    }
}
