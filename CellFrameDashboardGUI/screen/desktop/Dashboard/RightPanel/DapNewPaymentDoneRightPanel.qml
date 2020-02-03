import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        var chain = dapServiceController.CurrentNetwork === "private" ? "gdb": "plasma"
        dapServiceController.requestToService("DapMempoolProcessCommand", dapServiceController.CurrentNetwork, chain)

        nextActivated("transaction done")
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}
