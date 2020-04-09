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
        for(var i=0; i < dapModelWallets.count; ++i)
        {
            modelHistory.clear()
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
                modelHistory.append({ "wallet" : walletHistory[q].Wallet,
                                      "name" : walletHistory[q].Name,
                                      "status" : walletHistory[q].Status,
                                      "amount" : walletHistory[q].Amount,
                                      "date" : walletHistory[q].Date})
            }
        }
    }
}
