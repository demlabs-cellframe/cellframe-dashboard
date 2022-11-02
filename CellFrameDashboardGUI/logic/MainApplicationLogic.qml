import QtQuick 2.12
import QtQml 2.12

QtObject {
    property var  currentIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    property string nodeVersion:""

    //wallets create param
    property bool restoreWalletMode: false
    property string currentTab: params.isMobile ? "" : mainScreenStack.currPage
    property string walletRecoveryType: "Nothing"
    property string walletType: "Standart"
    //

    property string menuTabStates: ""
    property var networkArray: ""

    readonly property int autoUpdateInterval: 4000
    readonly property int autoUpdateHistoryInterval: 4000

    property bool stateNotify: false

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

    function updateMenuTabStatus()
    {
        var datamodel = []
        for (var i = 0; i < modelMenuTabStates.count; ++i)
            datamodel.push(modelMenuTabStates.get(i))

        for (var i = 0; i < modelAppsTabStates.count; ++i)
            datamodel.push(modelAppsTabStates.get(i))

        menuTabStates = JSON.stringify(datamodel)
    }

    function updateAppsTabStatus(auto, removed, name)
    {
        if(auto){
            for(var i = 0; i < modelAppsTabStates.count; i++){
                modelMenuTab.append({name: qsTr(modelAppsTabStates.get(i).name),
                                    tag: modelAppsTabStates.get(i).tag,
                                    page: modelAppsTabStates.get(i).path,
                                    bttnIco: "icon_certificates.svg",
                                    showTab: modelAppsTabStates.get(i).show})
            }
        }else{
            var index;
            if(removed){
                for(var i = 0; i < modelMenuTab.count; i++){
                    if(modelMenuTab.get(i).name === name){
                        modelMenuTab.remove(i);
                        break;
                    }
                }
            }else{
                for(var i = 0; i < modelAppsTabStates.count; i++){
                    if(modelAppsTabStates.get(i).name === name){
                        modelMenuTab.append({name: qsTr(modelAppsTabStates.get(i).name),
                                            tag: modelAppsTabStates.get(i).tag,
                                            page: modelAppsTabStates.get(i).path,
                                            bttnIco: "icon_certificates.svg",
                                            showTab: modelAppsTabStates.get(i).show})
                        break;
                    }
                }
            }
        }
        updateMenuTabStatus()
    }

    function initTabs()
    {
        for (var j = 0; j < modelMenuTabStates.count; ++j){
            for (var k = 0; k < modelMenuTab.count; ++k){
                if (modelMenuTabStates.get(j).tag ===
                    modelMenuTab.get(k).tag){

                    modelMenuTab.get(k).showTab = modelMenuTabStates.get(j).show
                    break
                }
            }
        }
        for (var j = 0; j < modelAppsTabStates.count; ++j){
            for (var k = 0; k < modelMenuTab.count; ++k){
                if (modelAppsTabStates.get(j).tag ===
                    modelMenuTab.get(k).tag &&
                    modelAppsTabStates.get(j).name ===
                    modelMenuTab.get(k).name){

                    modelMenuTab.get(k).showTab = modelAppsTabStates.get(j).show
                    break
                }
            }
        }
    }

    function loadSettingsTab()
    {
        var datamodel = JSON.parse(menuTabStates)

        for (var i = 0; i < datamodel.length; ++i){
            for (var j = 0; j < modelMenuTabStates.count; ++j){
                if (datamodel[i].tag ===modelMenuTabStates.get(j).tag){

                    modelMenuTabStates.get(j).show = datamodel[i].show
                    break
                }
            }
        }
        for (var i = 0; i < datamodel.length; ++i){
            for (var j = 0; j < modelAppsTabStates.count; ++j){
                if (datamodel[i].tag ===
                        modelAppsTabStates.get(j).tag &&
                        modelAppsTabStates.get(j).name ===
                        datamodel[i].name){

                    modelAppsTabStates.get(j).show = datamodel[i].show
                    break
                }
            }
        }
    }

    function updateModelAppsTab() //create model apps from left menu tab
    {
        if(modelAppsTabStates.count){
            for(var i = 0; i < dapModelPlugins.count; i++){
                var indexCreate;
                for(var j = 0; j < modelAppsTabStates.count; j++){
                    if(dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name && dapModelPlugins.get(i).status !== "1"){
                        pluginsTabChanged(false, true, modelAppsTabStates.get(j).name)
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
                                               show:true})

                    pluginsTabChanged(false, false, dapModelPlugins.get(indexCreate).name)
                    break
                }
            }
        }else{
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:dapModelPlugins.get(i).name,
                                               path: dapModelPlugins.get(i).path,
                                               verified:dapModelPlugins.get(i).verifed,
                                               show:true})

            }
            if(modelMenuTab.count)
                pluginsTabChanged(true,false,"")
        }
    }


    function rcvNetList(networksList)
    {
        if (!networksList.length)
            console.error("networksList is empty")
        else
        {
            if (networksModel.count !== networksList.length)
            {
                dapServiceController.requestToService("DapGetNetworksStateCommand")
            }

            if(dapNetworkModel.count !== networksList.length)
            {
                if(currentNetwork === -1)
                {
                    dapServiceController.setCurrentNetwork(networksList[0]);
                    dapServiceController.setIndexCurrentNetwork(0);
                    logicMainApp.currentNetwork = dapServiceController.IndexCurrentNetwork
                }
                else
                {
                    dapServiceController.setCurrentNetwork(networksList[currentNetwork]);
                    dapServiceController.setIndexCurrentNetwork(currentNetwork);
                }

                dapNetworkModel.clear()
                for (var i = 0; i < networksList.length; ++i)
                    dapNetworkModel.append({ "name" : networksList[i]})

                console.info("Current network: "+dapServiceController.CurrentNetwork)
            }

        }
    }

    function rcvWallets(walletList)
    {
        var jsonDocument = JSON.parse(walletList)

        if(!jsonDocument.length)
        {
            dapModelWallets.clear()
            return
        }

        dapModelWallets.clear()
        dapModelWallets.append(jsonDocument)

        if (currentIndex < 0 && dapModelWallets.count > 0)
            currentIndex = 0
        if (dapModelWallets.count < 0)
            currentIndex = -1

        modelWalletsUpdated()
    }

    function rcvWallet(wallet)
    {
        var jsonDocument = JSON.parse(walletList)

        if(!jsonDocument.length || jsonDocument.networks.length)
        {
            dapModelWallets.clear()
            return
        }

        dapModelWallets.append(jsonDocument)

        for (var i = 0; i < dapModelWallets.count; ++i)
        {
            if (dapModelWallets.get(i).name === jsonDocument.name)
            {
                dapModelWallets.get(i).networks.clear()
                dapModelWallets.get(i).status = jsonDocument.status

                if(jsonDocument.status === "" || jsonDocument.status === "Active")
                {
                    dapModelWallets.get(i).networks.append(jsonDocument.networks)
                }
            }
        }
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

    function rcvPairsModel(rcvData)
    {
//        console.log("rcvPairsModel", rcvData)

        if(rcvData !== "isEqual")
        {
            var jsonDocument = JSON.parse(rcvData)

            if(dapPairModel.count > 0)
            {
                token1Name = dapPairModel.get(currentIndexPair).token1
                token2Name = dapPairModel.get(currentIndexPair).token2
                tokenNetwork = dapPairModel.get(currentIndexPair).network

                stockDataWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

                dapPairModel.clear()
                dapPairModel.append(jsonDocument)

                for(var i = 0; i < dapPairModel.count; i++)
                {
                    var token1New = dapPairModel.get(i).token1
                    var token2New = dapPairModel.get(i).token2
                    var networkNew = dapPairModel.get(i).network

                    if (token1Name === token1New &&
                        token2Name === token2New &&
                        tokenNetwork === networkNew)
                    {
                        currentIndexPair = i
                        modelPairsUpdated()
                        return
                    }
                }
            }
            else
            {
                dapPairModel.clear()
                dapPairModel.append(jsonDocument)
                currentIndexPair = 0

                if(dapPairModel.count > 0)
                {
                    token1Name = dapPairModel.get(currentIndexPair).token1
                    token2Name = dapPairModel.get(currentIndexPair).token2
                    tokenNetwork = dapPairModel.get(currentIndexPair).network
                }
                else
                {
                    token1Name = ""
                    token2Name = ""
                    tokenNetwork = ""
                }

                stockDataWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

                modelPairsUpdated()
            }
        }
    }

    function rcvTokenPriceHistory(rcvData)
    {
        if(rcvData !== "")
        {
            if (!simulationStock)
                stockDataWorker.setTokenPriceHistory(rcvData)

            var jsonDocument = JSON.parse(rcvData)

//            print("rcvData", rcvData)
            dapTokenPriceHistory.clear()
            dapTokenPriceHistory.append(jsonDocument.history)

/*            var jsonDocument = JSON.parse(rcvData)

            print("rcvData", rcvData)
            dapTokenPriceHistory.clear()
            dapTokenPriceHistory.append(jsonDocument.history)
//            modelTokenPriceHistoryUpdated()


            print("dapTokenPriceHistory");
            print(jsonDocument.network,
                  jsonDocument.token1,
                  jsonDocument.token2)

            print(dapTokenPriceHistory.count)

            for(var i = 0; i < dapTokenPriceHistory.count; i++)
            {
                console.log(dapTokenPriceHistory.get(i).date,
                            dapTokenPriceHistory.get(i).rate)
            }*/
        }
    }

    function rcvStateNotify(isError, isFirst)
    {
        messagePopup.dapButtonCancel.visible = false
        messagePopup.dapButtonOk.textButton = "Ok"

        if(isError)
        {
            if(isFirst)
                messagePopup.smartOpen("Notify socket", qsTr("Lost connection to the Node. Reconnecting..."))
            console.warn("ERROR SOCKET")
            stateNotify = false
        }
        else
        {
            messagePopup.close()
            if(isFirst)
                console.info("CONNECT SOCKET")

            if(!stateNotify) //TODO with notify
                dapServiceController.requestToService("DapGetNetworksStateCommand")
            stateNotify = true
        }
    }

    function getAllWalletHistory(index, update)
    {
        if (index < 0 || index >= dapModelWallets.count)
            return

        var network_array = ""

        var name = dapModelWallets.get(index).name

        var model = dapModelWallets.get(index).networks

        for (var i = 0; i < model.count; ++i)
        {
            network_array += model.get(i).name + ":"
            network_array += name + "/"
        }
        dapServiceController.requestToService("DapGetAllWalletHistoryCommand", network_array, update);
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
                    dapServiceController.notifyService("DapWebConnectRequest",false, rcvData[1])
                    dapMessageLogBuffer.append({infoText: "The site " + rcvData[0] + " requests permission to exchange work with the wallet",
                                                date: logicMainApp.getDate("yyyy-MM-dd, hh:mm ap"),
                                                reply: "Denied"})
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
                }else{
                    isSingle = true
                    webPopup.setDisplayText(isSingle, rcvData[0], rcvData[1])
                }
                if(!webPopup.isOpen)
                    webPopup.open()
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

        messagePopupVersion.smartOpen("Dashboard update", qsTr("Current version - " + currVer +"\n"+
                                                   "Last version - " + lastVer +"\n" +
                                                   "Go to website to download?"))
    }

    function rcvReplyVersion()
    {
        messagePopupVersion.dapButtonCancel.visible = false
        messagePopupVersion.dapButtonOk.textButton = "Ok"

        messagePopupVersion.smartOpen("Dashboard update", qsTr("You have the latest version installed."))
    }

    function updateDashboard()
    {
        Qt.openUrlExternally(urlDownload);
//        dapServiceController.requestToService("DapVersionController", "update")
//        updatingDashboard("The update process has started.")
    }

    function updatingDashboard(message)
    {
        messagePopupVersion.dapButtonCancel.visible = false
        messagePopupVersion.dapButtonOk.textButton = "Ok"
        messagePopupVersion.smartOpen("New version", qsTr(message))

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
}
