import QtQuick 2.0
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"

DapPage {

    id:tokensTab
//    color: currTheme.backgroundMainScreen
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsTokens: path + "/Tokens/RightPanel/DapLastActionsRightPanel.qml"

    property alias dapTokensRightPanel: stackViewRightPanel

    signal resetWalletHistory()

    property var walletInfo:
    {
        "name": "",
        "network": "",
        "address": "",
        "chain": "",
        "signature_type": "",
        "recovery_hash": ""
    }

    property var tokensInfo:
    {
        "name": "",
        "balance": "",
        "emission": "",
        "network": "",
        "selected": ""
    }

    property int selectedIndex: -1

//    dapTopPanel:
//        DapTokensTopPanel{}

//    dapScreen:
//        DapTokensScreen
//        {
//            id: tokensScreen
////            onSelectedIndex: {   //index
////                setSelectedIndex(index)
////            }

////            function setSelectedIndex(index){
////                tokensTab.selectedIndex = index
////                for (var i = 0; i < dapModelWallets.count; ++i)
////                     setProperty(i, "selected", index === i)
////            }
//        }

//    dapRightPanel:
//        StackView
//        {
//            id: stackViewRightPanel
//            initialItem: Qt.resolvedUrl(lastActionsTokens);
//            width: 350 * pt
//            anchors.fill: parent
//            delegate:
//                StackViewDelegate
//                {
//                    pushTransition: StackViewTransition { }
//                }
//        }

    // Signal-slot connection realizing panel switching depending on predefined rules
    Connections
    {
        target: currentRightPanel
        onNextActivated:
        {
            currentRightPanel = dapTokensRightPanel.push(currentRightPanel.dapNextRightPanel);
            if(parametrsRightPanel === lastActionsTokens)
            {
//                getWalletHistory(currentWalletIndex,
//                    dapModelWallets.get(currentWalletIndex).networks)
            }
        }
        onPreviousActivated:
        {
            currentRightPanel = dapTokensRightPanel.push(currentRightPanel.dapPreviousRightPanel);
            if(parametrsRightPanel === lastActionsTokens)
            {
                if(dapModelWallets.count === 0)
                    state = "WALLETDEFAULT"
            }
//                getWalletHistory(currentWalletIndex,
//                    dapModelWallets.get(currentWalletIndex).networks)
        }
    }

    Connections
    {
        target: dapServiceController
        onWalletHistoryReceived:
        {
            for (var q = 0; q < walletHistory.length; ++q)
            {
/*                console.info("WALLET HISTORY Wallet =", walletHistory[q].Wallet)
                console.info("WALLET HISTORY Name =", walletHistory[q].Name)
                console.info("WALLET HISTORY Status =", walletHistory[q].Status)
                console.info("WALLET HISTORY Amount =", walletHistory[q].Amount)
                console.info("WALLET HISTORY Date =", walletHistory[q].Date)*/

//                modelHistory.append({ "wallet" : walletHistory[q].Wallet,
//                                      "name" : walletHistory[q].Name,
//                                      "status" : walletHistory[q].Status,
//                                      "amount" : walletHistory[q].Amount,
//                                      "date" : walletHistory[q].Date})
            }
        }
        onMempoolProcessed:
        {
            update()
        }
        onWalletCreated:
        {
            update()
        }
    }

    Component.onCompleted:
    {
//        for(var i=0; i < dapWallets.count; ++i)
//        {
//            modelHistory.clear()
//            dapServiceController.requestToService("DapGetWalletHistoryCommand",
//                                                  dapServiceController.CurrentNetwork,
//                                                  dapServiceController.CurrentChain,
//                                                  dapWallets[i].findAddress(dapServiceController.CurrentNetwork),
//                                                  dapWallets[i].Name)
//        }
        if(logicMainApp.currentIndex != -1)
        {
//            for (var i = 0; i < dapModelWallets(SettingsWallet.currentIndex).Tokens.count; ++i)
//            {
//                tokensInfo(i).
//            }
                tokensScreen.dapListViewTokens.model = dapModelWallets.get(logicMainApp.currentIndex).networks
        }
    }

    function update()
    {
        dapWallets.length = 0
        dapModelWallets.clear()
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
    }

    function getWalletHistory(index, model)
    {
        console.log("getWalletHistory", index, model.count, model.get(0).name)

        resetWalletHistory()

        for (var i = 0; i < model.count; ++i)
        {
            walletInfo.network = model.get(i).name
            walletInfo.address = dapWallets[index].findAddress(walletInfo.network)
            if (walletInfo.network === "core-t")
                walletInfo.chain = "zerochain"
            else
                walletInfo.chain = "zero"

            console.log("DapGetWalletHistoryCommand")
            console.log("   network: " + walletInfo.network)
            console.log("   chain: " + walletInfo.chain)
            console.log("   wallet address: " + walletInfo.address)
            dapServiceController.requestToService("DapGetWalletHistoryCommand",
                walletInfo.network, walletInfo.chain, walletInfo.address);
        }
    }
}
