import QtQuick 2.4

DapDashboardTopPanelForm 
{
    dapAddWalletButton.onClicked: 
    {
        dapServiceController.requestToService("ADD", 5);
    }
}
