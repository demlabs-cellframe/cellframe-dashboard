import QtQuick 2.4

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
        for(var i=0; i < dapWallets.count; ++i)
        {
            modelHistory.clear()

            // TODO: Here we need to get the values of CurrentNetwork and CurrentChain
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            console.log("WALLET HISTORY RECIEVED")
            for (var q = 0; q < walletHistory.length; ++q)
            {
                console.info("WALLET HISTORY Wallet =", walletHistory[q].Wallet)
                console.info("WALLET HISTORY Name =", walletHistory[q].Name)
                console.info("WALLET HISTORY Status =", walletHistory[q].Status)
                console.info("WALLET HISTORY Amount =", walletHistory[q].Amount)
                console.info("WALLET HISTORY Date =", walletHistory[q].Date)

                modelHistory.append({ "wallet" : walletHistory[q].Wallet,
                                      "name" : walletHistory[q].Name,
                                      "status" : walletHistory[q].Status,
                                      "amount" : walletHistory[q].Amount,
                                      "date" : walletHistory[q].Date})
            }
        }
    }
}
