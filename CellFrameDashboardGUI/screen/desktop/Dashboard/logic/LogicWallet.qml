import QtQuick 2.12
import QtQml 2.12

QtObject {

    property bool restoreWalletMode: false

    function updateAllWallets()
    {
        dapModelWallets.clear()
        logicMainApp.requestToService("DapGetWalletsInfoCommand", "true");
    }

    function updateCurrentWallet()
    {
//        print("updateCurrentWallet", logicMainApp.currentIndex, dapModelWallets.get(logicMainApp.currentIndex).status )

        if (logicMainApp.currentWalletIndex !== -1)
        {
            if(logicMainApp.currentWalletIndex < dapModelWallets.count)
            {
                logicMainApp.currentWalletIndex--
                return
            }

            logicMainApp.requestToService("DapGetWalletInfoCommand",
                dapModelWallets.get(logicMainApp.currentWalletIndex).name)
        }
    }

    function updateWalletModel()
    {
        if(logicMainApp.currentWalletIndex !== -1)
        {
            if(dapModelWallets.count)
            {
                dashboardScreen.dapListViewWallet.model = dapModelWallets.get(logicMainApp.currentWalletIndex).networks
//                dashboardTopPanel.dapFrameTitle.fullText = dapModelWallets.get(logicMainApp.currentWalletIndex).name

//                console.log("dapComboboxWallet.onCurrentIndexChanged")

                dashboardTab.state = "WALLETSHOW"
            }
        }
    }

    function initNetworks()
    {
        networksModel.clear()

        var tempNetworks = dapModelWallets.
            get(logicMainApp.currentWalletIndex).networks

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
