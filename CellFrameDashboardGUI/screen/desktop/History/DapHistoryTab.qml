import QtQuick 2.4

DapHistoryTabForm
{
    ListModel
    {
        id: modelHistory
    }

    dapHistoryTopPanel.dapTextFieldSearch.onTextChanged:
    {
        if(dapHistoryTopPanel.dapTextFieldSearch.text == "")
        {
            modelHistory.clear()
            for(var i=0; i < dapModelWallets.count; ++i)
            {
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                      dapServiceController.CurrentNetwork,
                                                      dapServiceController.CurrentChain,
                                                      dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                      dapWallets[i].Name,
                                                      "",
                                                      "",
                                                      dapHistoryTopPanel.dapComboboxWallet.currentText,
                                                      dapHistoryTopPanel.dapComboboxStatus.currentText,
                                                      dapHistoryTopPanel.dapTextFieldSearch.text)
            }
        }
    }

    dapHistoryTopPanel.dapButtonSearch.onClicked:
    {
        console.log(dapHistoryTopPanel.dapTextFieldSearch.text)
        modelHistory.clear()
        for(var i=0; i < dapModelWallets.count; ++i)
        {
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name,
                                                  "",
                                                  "",
                                                  dapHistoryTopPanel.dapComboboxWallet.currentText,
                                                  dapHistoryTopPanel.dapComboboxStatus.currentText,
                                                  dapHistoryTopPanel.dapTextFieldSearch.text)
        }
    }

    dapHistoryTopPanel.dapComboboxPeriod.onCurrentTextChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxPeriod.currentText)
        modelHistory.clear()
        for(var i=0; i < dapModelWallets.count; ++i)
        {
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name,
                                                  "",
                                                  "",
                                                  dapHistoryTopPanel.dapComboboxWallet.currentText,
                                                  dapHistoryTopPanel.dapComboboxStatus.currentText)
        }
    }

    dapHistoryTopPanel.dapComboboxWallet.onCurrentIndexChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxWallet.mainLineText)
        modelHistory.clear()
        for(var i=0; i < dapModelWallets.count; ++i)
        {
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name,
                                                  "",
                                                  "",
                                                  dapHistoryTopPanel.dapComboboxWallet.currentText,
                                                  dapHistoryTopPanel.dapComboboxStatus.currentText)
        }
    }

    dapHistoryTopPanel.dapComboboxStatus.onCurrentTextChanged:
    {
        console.log(dapHistoryTopPanel.dapComboboxStatus.currentText)
        modelHistory.clear()
        for(var i=0; i < dapModelWallets.count; ++i)
        {
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                                                  dapServiceController.CurrentNetwork,
                                                  dapServiceController.CurrentChain,
                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
                                                  dapWallets[i].Name,
                                                  "",
                                                  "",
                                                  dapHistoryTopPanel.dapComboboxWallet.currentText,
                                                  dapHistoryTopPanel.dapComboboxStatus.currentText)
        }
    }

    Component.onCompleted:
    {
        modelHistory.clear()
        for(var i=0; i < dapModelWallets.count; ++i)
        {
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
