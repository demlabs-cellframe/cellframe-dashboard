import QtQuick 2.4

DapDashboardTopPanelForm 
{
    ListModel 
    {
        id: modelWallets
    }

    ListModel
    {
        id: modelTokens
    }
    
    function updateModel(wallet)
    {
        console.log(wallet)
        if(wallet[1] === "created")
            modelWallets.append({ "name" : wallet[0] })
    }

    dapAddWalletButton.onClicked: 
    {
        dapServiceController.requestToService("ADD", "MYNEWWALLET");
    }
}
