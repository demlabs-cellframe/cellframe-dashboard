import QtQuick 2.4

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        dapServiceController.requestToService("DapMempoolProcessCommand", "private", "gdb")
    }
}
