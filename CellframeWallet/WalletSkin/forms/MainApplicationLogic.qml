import QtQuick 2.12
import QtQml 2.12

QtObject {

    property string currentPage:""


    property var  currentWalletIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    property int currentLanguageIndex: 0
    property string currentLanguageName: "en"

    property var commandResult

    property string nodeVersion:""

    //wallets create param
    property bool restoreWalletMode: false
    property string walletRecoveryType: "Nothing"
    property string walletType: ""
    property string walletPass: ""
    property string walletRecoveryHash: ""
    property string walletSign: ""
    property string walletName: ""

    //
    property string menuTabStates: ""

    property string currentWalletName: ""
    property string currentNetworkName: ""

    readonly property int autoUpdateInterval: 1000
    readonly property int autoUpdateHistoryInterval: 4000

    property string lastVersion
    property bool hasUpdate
    property string urlDownload

    property int requestsMessageCounter: 0
    property bool isOpenRequests: false
    property int currentIndexPair: -1

    property string token1Name: ""
    property string token2Name: ""
    property string tokenNetwork: ""
    property real tokenPrice
    property string tokenPriceText

    property bool simulationStock: false
    property int currentRoundPowerIndex: 0

    ///Functions
    function updateAllWallets()
    {
        dapModelWallets.clear()
    }

    function updateCurrentWallet()
    {
    }

    function updateMenuTabStatus()
    {
        var datamodel = []

        for (var i = 0; i < modelAppsTabStates.count; ++i)
            datamodel.push(modelAppsTabStates.get(i))

        menuTabStates = JSON.stringify(datamodel)
    }

    function loadSettingsTab()
    {
        var datamodel = JSON.parse(menuTabStates)

        for (var i = 0; i < datamodel.length; ++i){
            for (var j = 0; j < modelAppsTabStates.count; ++j){
                if (datamodel[i].tag ===
                        modelAppsTabStates.get(j).tag &&
                        modelAppsTabStates.get(j).name ===
                        datamodel[i].name){

                    modelAppsTabStates.get(j).showTab = datamodel[i].showTab
                    break
                }
            }
        }
    }

    function updateModelAppsTab() //create model apps from left menu tab
    {
        if(modelAppsTabStates.count){
            if(!dapModelPlugins.count)
                modelAppsTabStates.clear()

            for(var i = 0; i < dapModelPlugins.count; i++){
                var indexCreate;
                for(var j = 0; j < modelAppsTabStates.count; j++){
                    if(dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name && dapModelPlugins.get(i).status !== "1" ||
                       dapModelPlugins.get(i).name.replace(".zip", "") === modelAppsTabStates.get(j).name && dapModelPlugins.get(i).status !== "1"){
                        updateMenuTabStatus()
                        modelAppsTabStates.remove(j);
                        j--;
                    }else if(dapModelPlugins.get(i).status === "1" && dapModelPlugins.get(i).name !== modelAppsTabStates.get(j).name){
                        indexCreate = i;
                    }else if(dapModelPlugins.get(i).status === "1" && dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name){
                        indexCreate = -1;
                        break
                    }
                }
                if(indexCreate >= 0)
                {
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:dapModelPlugins.get(indexCreate).name,
                                               path: dapModelPlugins.get(indexCreate).path,
                                               verified:dapModelPlugins.get(indexCreate).verifed,
                                               showTab:true})
                    updateMenuTabStatus()
                    break
                }
            }
        }
        else
        {
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:dapModelPlugins.get(i).name,
                                               path: dapModelPlugins.get(i).path,
                                               verified:dapModelPlugins.get(i).verifed,
                                               showTab:true})

            }
            updateMenuTabStatus()
        }
    }




    function updateContentForExistingModel(curModel, newData)
    {
        if (isNetworkListsEqual(curModel, newData)) {
            for (var i=0; i<curModel.count; ++i) {
                if (curModel.get(i).name !== newData[i].name)
                    curModel.set(i, {"name": newData[i].name})
                if (curModel.get(i).networkState !== newData[i].networkState)
                    curModel.set(i, {"networkState": newData[i].networkState})
                if (curModel.get(i).targetState !== newData[i].targetState)
                    curModel.set(i, {"targetState": newData[i].targetState})
                if (curModel.get(i).errorMessage !== newData[i].errorMessage)
                    curModel.set(i, {"errorMessage": newData[i].errorMessage})
                if (curModel.get(i).linksCount !== newData[i].linksCount)
                    curModel.set(i, {"linksCount": newData[i].linksCount})
                if (curModel.get(i).activeLinksCount !== newData[i].activeLinksCount)
                    curModel.set(i, {"activeLinksCount": newData[i].activeLinksCount})
                if (curModel.get(i).nodeAddress !== newData[i].nodeAddress)
                    curModel.set(i, {"nodeAddress": newData[i].nodeAddress})
            }
        }
    }

//     function rcvWallets(walletList)
//     {
// //        console.log("rcvWallets", "walletList", walletList)

//         if (walletList === "isEqual")
//             return

//         var jsonDocument = JSON.parse(walletList)

//         if(!jsonDocument)
//         {
//             dapModelWallets.clear()
//             return
//         }

//         dapModelWallets.clear()
//         dapModelWallets.append(jsonDocument)

//         console.log("rcvWallets", "currentWalletName", currentWalletName)

//         var nameIndex = -1

//         for (var i = 0; i < dapModelWallets.count; ++i)
//         {
//             if (dapModelWallets.get(i).name === currentWalletName)
//                 nameIndex = i
//         }

//         console.log("rcvWallets", "nameIndex", nameIndex)

//         if (nameIndex >= 0)
//         {
//             currentWalletIndex = nameIndex
//             comboBoxCurrentWallet.setCurrentIndex(nameIndex)
//         }

//         if (currentWalletIndex < 0 && dapModelWallets.count > 0)
//             currentWalletIndex = 0
//         if (dapModelWallets.count < 0)
//             currentWalletIndex = -1

//         modelWalletsUpdated()
//     }

    function rcvWallet(wallet)
    {
        if(wallet === "")
        {
            dapModelWallets.clear()
            return
        }

        var jsonDocument = JSON.parse(wallet)

        if(!jsonDocument)
        {
            dapModelWallets.clear()
            return
        }

        for (var i = 0; i < dapModelWallets.count; ++i)
        {
            if (dapModelWallets.get(i).name === jsonDocument.name)
            {
                dapModelWallets.get(i).status = jsonDocument.status

                if(jsonDocument.status === "" || jsonDocument.status === "Active")
                {
                    dapModelWallets.get(i).networks = jsonDocument.networks
                }
            }
        }
        modelWalletsUpdated()
    }

    function rcvOrders(orderList)
    {
        if(orderList.length !== dapModelOrders.count)
        {
            dapModelOrders.clear()
            for (var i = 0; i < orderList.length; ++i)
                dapModelOrders.append({ "index" : orderList[i].Index,
                                      "location" : orderList[i].Location,
                                      "network" : orderList[i].Network,
                                      "node_addr" : orderList[i].AddrNode,
                                      "price" : orderList[i].TotalPrice})
        }
    }

    function rcvPlugins(m_pluginsList)
    {
        dapModelPlugins.clear()
        for(var q = 0; q < m_pluginsList.length; q++)
            dapModelPlugins.append({"name" : m_pluginsList[q][0],
                                    "path" : m_pluginsList[q][1],
                                    "status" : m_pluginsList[q][2],
                                    "verifed" : m_pluginsList[q][3]})

    }

    function rcvTokens(tokensList)
    {
        if(tokensList !== "isEqual")
        {
            var jsonDocument = JSON.parse(tokensList)
            dapModelTokens.clear()
            dapModelTokens.append(jsonDocument)
            modelTokensUpdated()
        }
    }

    function rcvOpenOrders(rcvData)
    {
        if(rcvData !== "isEqual")
        {
            if (!simulationStock)
                stockDataWorker.setBookModel(rcvData)

            var jsonDocument = JSON.parse(rcvData)
            dapModelXchangeOrders.clear()
            dapModelXchangeOrders.append(jsonDocument)
            modelXchangeOrdersUpdated()
/*            print("rcvOpenOrders", dapModelXchangeOrders.count)

            for(var i = 0; i < dapModelXchangeOrders.count; i++)
            {
                console.log(dapModelXchangeOrders.get(i).network,
                            dapModelXchangeOrders.get(i).orders.count)

                for(var j = 0; j < dapModelXchangeOrders.get(i).orders.count; j++)
                {
                    var orderNet = dapModelXchangeOrders.get(i).network
                    var orderBuy = dapModelXchangeOrders.get(i).orders.get(j).buy_token
                    var orderSell = dapModelXchangeOrders.get(i).orders.get(j).sell_token
                    var orderPrice = parseFloat(dapModelXchangeOrders.get(i).orders.get(j).rate)
                    var orderSellAmount = dapModelXchangeOrders.get(i).orders.get(j).sell_amount
                    var orderBuyAmount = dapModelXchangeOrders.get(i).orders.get(j).buy_amount
                    var orderHash = dapModelXchangeOrders.get(i).orders.get(j).order_hash

                    console.log(orderBuy,
                                orderSell,
                                orderPrice,
                                orderSellAmount,
                                orderBuyAmount)
                }
            }*/

        }
    }

    function rcvStateNotify(isConnected)
    {
        messagePopup.dapButtonCancel.visible = false
        messagePopup.dapButtonOk.textButton = "Ok"

        if(!isConnected)
        {
            if(OS_WIN_FLAG)
                messagePopup.smartOpen(qsTr("Notify socket"), qsTr("Lost connection to the Node. Please restart the node"))
            else
                messagePopup.smartOpen(qsTr("Notify socket"), qsTr("Lost connection to the Node. Reconnecting..."))
            console.warn("ERROR SOCKET")
        }
        else
        {
            messagePopup.close()
            console.info("CONNECT SOCKET")
            // requestToService("DapGetNetworksStateCommand")
        }
    }

    function getAllWalletHistory(index, update, isLastActions)
    {
        if (index < 0 || index >= dapModelWallets.count)
            return

        var network_array = ""

        var name = dapModelWallets.get(index).name

        var model = dapModelWallets.get(index).networks

        if(model)
        {
            for (var i = 0; i < model.count; ++i)
            {
                network_array += model.get(i).name + ":"
                network_array += model.get(i).address + ":"
                network_array += name + "/"
            }
            // requestToService("DapGetWalletHistoryCommand",
            //                  network_array, update, isLastActions)
        }
    }

    function rcvWebConnectRequest(rcvData)
    {
        var isEqual = false
        //filtering equeal sites requests
        for(var i = 0; i < dapMessageBuffer.count; i++)
        {
            if(dapMessageBuffer.get(i).site === rcvData[0]){
                isEqual = true
                break;
            }
        }

        var isContains = false;
        for(var j = 0; j < dapWebSites.count; j++)
        {
            if(dapWebSites.get(j).site === rcvData[0])
            {
                isContains = true
                if(!dapWebSites.get(j).enabled)
                {
                    app.webConnectRespond(false, rcvData[1])
                    return
                }
            }
        }

        if(!isContains)
            dapWebSites.append({site:rcvData[0],
                                enabled: true})

        if(!isEqual)
        {
            requestsMessageCounter++
            dapMessageBuffer.append({indexRequest: rcvData[1],
                                     site: rcvData[0],
                                     date: getDate("yyyy-MM-dd, hh:mm ap")})

            if(!isOpenRequests)
            {
                var isSingle
                if(requestsMessageCounter > 1)
                {
                    isSingle = false
                    webPopup.setDisplayText(isSingle, requestsMessageCounter, -1)
                }
                else
                {
                    isSingle = true
                    webPopup.setDisplayText(isSingle, rcvData[0], rcvData[1])
                }
                if(!webPopup.isOpen)
                {
                    webPopup.openPopup()
                }
            }
        }
    }

    function rcvNewVersion(currVer, lastVer, isHasUpdate, url)
    {
        lastVersion = lastVer
        hasUpdate = isHasUpdate
        urlDownload = url

        messagePopupVersion.dapButtonCancel.visible = true
        messagePopupVersion.dapButtonOk.textButton = "Update"
        messagePopupVersion.dapButtonCancel.textButton = "Cancel"

        messagePopupVersion.smartOpen(qsTr("Wallet update"), qsTr("Current version - ") + currVer +"\n"+
                                                   qsTr("Last version - ") + lastVer +"\n" +
                                                   qsTr("Go to website to download?"))
    }

    function rcvReplyVersion()
    {
        messagePopupVersion.dapButtonCancel.visible = false
        messagePopupVersion.dapButtonOk.textButton = "Ok"

        messagePopupVersion.smartOpen(qsTr("Wallet update"), qsTr("You have the latest version installed."))
    }

    function updateWallet()
    {
        Qt.openUrlExternally(urlDownload);
    }

    function updatingWallet(message)
    {
        messagePopupVersion.dapButtonCancel.visible = false
        messagePopupVersion.dapButtonOk.textButton = qsTr("Ok")
        messagePopupVersion.smartOpen(qsTr("New version"), qsTr(message))

        delay(5000,function() {Qt.quit()} )
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    function getDate(format){
        var date = new Date()
        return date.toLocaleString(Qt.locale("en_EN"),format)
    }

///////////// new

    function requestToService()
    {
        var service
        var args = []

        for(var i = 0; i < arguments.length; i++)
        {
            if(i == 0)
                service = arguments[i]
            else
            {
                args.push(arguments[i])
            }
        }

        var count  = args.length ? 10 - args.length : 0
        while(count)
        {
            args.push("");
            count--;
        }

        dapServiceController.requestToService(service, args);
    }
}
