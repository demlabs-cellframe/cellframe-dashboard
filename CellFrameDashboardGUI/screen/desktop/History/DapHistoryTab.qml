import QtQuick 2.4
import "../SettingsWallet.js" as SettingsWallet

DapHistoryTabForm
{
    ListModel
    {
        id: modelHistory
    }

    //Use only this signal "onDapResultTextChanged" instead "onCurrentIndexChanged" and "onCurrentTextChanged"
    dapHistoryTopPanel.dapComboboxPeriod.onDapResultTextChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxPeriod.dapResultText)
    }

    //Use only this signal "onMainLineTextChanged" instead "onCurrentIndexChanged" and "onCurrentTextChanged"
    dapHistoryTopPanel.dapComboboxWallet.onMainLineTextChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxWallet.mainLineText)
    }

    dapHistoryTopPanel.dapComboboxStatus.onCurrentTextChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxStatus.currentText)
    }

    Component.onCompleted:
    {
        modelHistory.clear()

        print("DapHistoryTabForm onCompleted")
        print("dapWallets.count", dapModelWallets.count)

        if (dapModelWallets.count > 0)
        {
            getWalletHistory(SettingsWallet.currentIndex)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
                if (modelHistory.count === 0)
                    modelHistory.append({"wallet" : walletHistory[q].Wallet,
                                          "network" : walletHistory[q].Network,
                                          "name" : walletHistory[q].Name,
                                          "status" : walletHistory[q].Status,
                                          "amount" : walletHistory[q].Amount,
                                          "date" : walletHistory[q].Date,
                                          "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
                else
                {
                    var j = 0;
                    while (modelHistory.get(j).SecsSinceEpoch > walletHistory[q].SecsSinceEpoch)
                    {
                        ++j;
                        if (j >= modelHistory.count)
                            break;
                    }
                    modelHistory.insert(j, {"wallet" : walletHistory[q].Wallet,
                                          "network" : walletHistory[q].Network,
                                          "name" : walletHistory[q].Name,
                                          "status" : walletHistory[q].Status,
                                          "amount" : walletHistory[q].Amount,
                                          "date" : walletHistory[q].Date,
                                          "SecsSinceEpoch" : walletHistory[q].SecsSinceEpoch})
                }

                print("walletHistory", "wallet", walletHistory[q].Wallet,
                      "network", walletHistory[q].Network,
                      "name", walletHistory[q].Name,
                      "status", walletHistory[q].Status,
                      "amount", walletHistory[q].Amount,
                      "date", walletHistory[q].Date,
                      "SecsSinceEpoch", walletHistory[q].SecsSinceEpoch)
            }
        }
    }

    function getWalletHistory(index)
    {
        if (index < 0)
            return;

        var model = dapModelWallets.get(index).networks
        var name = dapModelWallets.get(index).name

        console.log("getWalletHistory", index, model.count)

        for (var i = 0; i < model.count; ++i)
        {
            var network = model.get(i).name
            var address = model.get(i).address
            var chain = "zero"
            if (network === "core-t")
                chain = "zerochain"

            console.log("DapGetWalletHistoryCommand")
            console.log("   wallet name:", name)
            console.log("   network:", network)
            console.log("   chain:", chain)
            console.log("   wallet address:", address)
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                network, chain, address, name);
        }
    }
}
