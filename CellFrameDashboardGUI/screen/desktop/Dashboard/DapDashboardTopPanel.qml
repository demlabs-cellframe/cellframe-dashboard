import QtQuick 2.4

DapDashboardTopPanelForm 
{
    ListModel 
    {
        id: modelWallets
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            if(wallet[0] === true)
                updateModel(wallet)
            else
                console.log(wallet[1])
        }
    }
    
    function updateModel(wallet)
    {
        console.log(wallet[2])
        modelWallets.append({ "name" : wallet[1]})
    }

    dapAddWalletButton.onClicked: 
    {
//        dapServiceController.requestToService("DapAddWalletCommand", "MYNEWWALLET5", "sig_dil", "kelvin-testnet", "0xad12dec5ab4f");
        dapServiceController.requestToService("DapGetListWalletsCommand", "kelvin-testnet");
    }
}
