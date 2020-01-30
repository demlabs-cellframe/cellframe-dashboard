import QtQuick 2.4
import Demlabs 1.0

DapDashboardTopPanelForm 
{

    property var objectsArray: []


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
            objectsArray.push(factory.createStructure())
            for (var i = 0; i < objectsArray.length; ++i)
            {
                modelWallets.append({ "name" : objectsArray[i].Name,
                                      "balance" : objectsArray[i].Balance,
                                      "icon" : objectsArray[i].Icon,
                                      "address" : objectsArray[i].Address,
                                      "networks" : []})
                for (var n = 0; n < Object.keys(objectsArray[i].Networks).length; ++n)
                {
                     modelWallets.get(i).networks.append({"name": objectsArray[i].Networks[n],
                                                          "address": objectsArray[i].findAddress(objectsArray[i].Networks[n]),
                                                          "tokens": []})
//                    console.log(Object.keys(objectsArray[i].Tokens).length)
                    for (var t = 0; t < Object.keys(objectsArray[i].Tokens).length; ++t)
                    {
                        console.log(objectsArray[i].Tokens[t].Network + " === " + objectsArray[i].Networks[n])
                        if(objectsArray[i].Tokens[t].Network === objectsArray[i].Networks[n])
                        {
                             modelWallets.get(i).networks.get(n).tokens.append({"name": objectsArray[i].Tokens[t].Name,
                                                                                "balance": objectsArray[i].Tokens[t].Balance,
                                                                                "emission": objectsArray[i].Tokens[t].Emission,
                                                                                "network": objectsArray[i].Tokens[t].Network})
                        }
                    }

                }

            }
        }
    }

    dapAddWalletButton.onClicked: 
    {
//        dapServiceController.requestToService("DapAddWalletCommand", "MYNEWWALLET5", "sig_dil", "kelvin-testnet", "0xad12dec5ab4f");
        dapServiceController.requestToService("DapGetListWalletsCommand", "kelvin-testnet");
    }
}
