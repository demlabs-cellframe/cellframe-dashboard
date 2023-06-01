import QtQuick 2.12
import QtQml 2.12

QtObject {

    property bool restoreWalletMode: false
    property string walletType: "Standart"
    property string walletRecoveryType: "Words"

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

//        var nameIndex = -1

//        for (var i = 0; i < dapModelWallets.count; ++i)
//        {
//            if (dapModelWallets.get(i).name === modulesController.currentWalletName)
//                nameIndex = i
//        }

//        console.log("rcvWallets", "nameIndex", nameIndex)

//        if (nameIndex >= 0)
//            modulesController.currentWalletIndex = nameIndex

//        if (modulesController.currentWalletIndex < 0 && dapModelWallets.count > 0)
//            modulesController.currentWalletIndex = 0
//        if (dapModelWallets.count < 0)
//            modulesController.currentWalletIndex = -1

//        if(modulesController.currentWalletIndex !== -1)
//        {
        if(dapModelWallets.count)
        {
            dashboardScreen.listViewWallet.model = dapModelWallets.get(modulesController.currentWalletIndex).networks
            if(dashboardTab.state != "WALLETCREATE")
                dashboardTab.state = "WALLETSHOW"
        }
//        }
    }

    function updateWallet(wallet)
    {
        var jsonDocument = JSON.parse(wallet)

//        console.log("AAAAAAAAAAAAA", dapModelWallets.count, wallet, jsonDocument)

        if(!jsonDocument || (!jsonDocument.status && !jsonDocument.networks.length))
        {
            dapModelWallets.clear()
            return
        }

        for (var i = 0; i < dapModelWallets.count; ++i)
        {
            if (dapModelWallets.get(i).name === jsonDocument.name)
            {
//                dapModelWallets.set(i, jsonDocument)
//                return

                dapModelWallets.get(i).status = jsonDocument.status

                if(jsonDocument.status === "" || jsonDocument.status === "Active")
                {
//                    console.log(jsonDocument.networks)
                    dapModelWallets.get(i).networks.clear()
                    dapModelWallets.get(i).networks.append(jsonDocument.networks)
//                    dapModelWallets.get(i).networks = jsonDocument.networks
//                    console.log(dapModelWallets.get(i).networks)
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
