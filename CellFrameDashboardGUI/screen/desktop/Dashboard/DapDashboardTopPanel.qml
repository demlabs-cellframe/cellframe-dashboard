import QtQuick 2.4

DapDashboardTopPanelForm 
{
    ListModel 
    {
        id: modelWallets
    }
    
    function updateModel(name)
    {
        modelWallets.append({ "name" : name })
    }
    
    dapAddWalletButton.onClicked: 
    {
        dapServiceController.requestToService("ADD", 5);
    }
}
