import QtQuick 2.4
import Demlabs 1.0

DapDashboardTopPanelForm 
{
    DapWallet
    {
        id: wal
    }

    property var objectsArray: []
    ListModel 
    {
        id: modelWallets
    }

    ListModel
    {
        id: modelTokens
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
        onWalletsListReceived:
        {
            objectsArray.push(wal.fromVariant(wallet))
            for (var i = 0; i < objectsArray.length; ++i)
            {
//                var str = objectsArray[i].Name + objectsArray[i].Networks + objectsArray[i].getTokens("private").Balance + "\n"
                modelWallets.append({ "name" : objectsArray[i].Name})
            }
        }
    }
    
    function updateModel(nameWallet)
    {
        console.log(nameWallet)
        modelWallets.append({ "name" : nameWallet})
    }

    dapAddWalletButton.onClicked: 
    {
//        dapServiceController.requestToService("DapAddWalletCommand", "MYNEWWALLET5", "sig_dil", "kelvin-testnet", "0xad12dec5ab4f");
        dapServiceController.requestToService("DapGetListWalletsCommand", "kelvin-testnet");
    }
}
