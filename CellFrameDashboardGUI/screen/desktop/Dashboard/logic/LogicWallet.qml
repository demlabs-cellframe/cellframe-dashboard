import QtQuick 2.12
import QtQml 2.12

QtObject {

    property bool restoreWalletMode: false
    property string walletType: "Standart"
    property string walletRecoveryType: "Words"
    property string walletStatus: ""

    function updateWalletsModel(model)
    {
//        console.log(model)
        if(model == "isEqual")
            return

        var jsonDocument = JSON.parse(model)

        if(!jsonDocument)
        {
            dapModelWallets.clear()
            return
        }

        dapModelWallets.clear()
        dapModelWallets.append(jsonDocument)

//        console.log("rcvWallets", "currentWalletName", modulesController.currentWalletName)
//        console.log("rcvWallets", "nameIndex", nameIndex)

        if(dapModelWallets.count)
        {
            dashboardScreen.listViewWallet.model = dapModelWallets.get(modulesController.currentWalletIndex).networks
            if(dashboardTab.state != "WALLETCREATE")
                dashboardTab.state = "WALLETSHOW"
        }
    }

    function updateWallet(wallet)
    {        
        var jsonDocument = JSON.parse(wallet)

//        console.log(dapModelWallets.count, wallet, jsonDocument)

        if(!jsonDocument || (!jsonDocument.status && !jsonDocument.networks.length))
        {
            dapModelWallets.clear()
            return
        }
        for (var i = 0; i < dapModelWallets.count; ++i)
        {
//            console.log(dapModelWallets.get(i).name === jsonDocument.name)
            if (dapModelWallets.get(i).name === jsonDocument.name)
            {
                dapModelWallets.get(i).status = jsonDocument.status

//                console.log(jsonDocument.status)
                if(jsonDocument.status === "" || jsonDocument.status === "Active")
                {
//                    console.log(jsonDocument.networks)

                    if(dapModelWallets.get(i).networks)
                    {
                        dapModelWallets.get(i).networks.clear()
                        dapModelWallets.get(i).networks.append(jsonDocument.networks)
                    }
                    else
                    {
                        dapModelWallets.set(i, jsonDocument)
                    }
                }
                return
            }
        }
    }

    function initNetworks()
    {
        networksModel.clear()

        var tempNetworks = dapModelWallets.
            get(modulesController.currentWalletIndex).networks

        for (var i = 0; i < tempNetworks.count; ++i)
        {
            networksModel.append(
                        { "tokens" : []})

            for (var j = 0; j < tempNetworks.get(i).tokens.count; ++j)
            {
                networksModel.get(i).tokens.append(
                    { "name" : tempNetworks.get(i).tokens.get(j).name,
                      "datoshi": tempNetworks.get(i).tokens.get(j).datoshi,
                      "coins": tempNetworks.get(i).tokens.get(j).coins})
            }
        }
    }
}
