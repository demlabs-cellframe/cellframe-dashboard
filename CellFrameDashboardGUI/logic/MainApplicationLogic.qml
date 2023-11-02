import QtQuick 2.12
import QtQml 2.12

QtObject {
    property var  currentWalletIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    property string nodeVersion:""

    //wallets create param
    property bool restoreWalletMode: false
    property string currentTab: params.isMobile ? "" : mainScreenStack.currPage
    property string walletRecoveryType: "Nothing"
    property string walletType: "Standard"
    //
    property string menuTabStates: ""

    property string currentWalletName: ""
    property string currentNetworkName: ""

    property int currentLanguageIndex: 0
    property string currentLanguageName: "en"

    readonly property int autoUpdateInterval: 4000
    readonly property int autoUpdateHistoryInterval: 4000

    property bool stateNotify: false

    property string lastVersion
    property bool hasUpdate
    property string urlDownload

    property int requestsMessageCounter: 0
    property bool isOpenRequests: false
    property int currentIndexPair: 0

//    property string token1Name: ""
//    property string token2Name: ""
//    property string tokenNetwork: ""
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
//        console.log("net list rcv", networksList, dapNetworkModel.count, networksList.length)
        if (!networksList.length)
            console.error("networksList is empty")
        else
        {
            var nameIndex = -1

            for (var i = 0; i < networksList.length; ++i)
            {
//                dapNetworkModel.append({ "name" : networksList[i]})
                if (networksList[i] === currentNetworkName)
                    nameIndex = i
            }

            if (nameIndex >= 0)
                currentNetwork = nameIndex

            if (networksModel.count !== networksList.length || !stateNotify)
            {
                logicMainApp.requestToService("DapGetNetworksStateCommand")
            }

            if (dapNetworkModel.count !== networksList.length)
            {
                console.log("rcvNetList", "currentNetworkName", currentNetworkName)

                console.info("dapNetworkModel.count", dapNetworkModel.count,
                             "networksList.length", networksList.length)

                if (currentNetwork === -1)
                {
                    dapServiceController.setCurrentNetwork(networksList[0]);
                    dapServiceController.setIndexCurrentNetwork(0);
                    currentNetwork = dapServiceController.IndexCurrentNetwork
                }
                else
                {
                    dapServiceController.setCurrentNetwork(networksList[currentNetwork]);
                    dapServiceController.setIndexCurrentNetwork(currentNetwork);
                }

                dapNetworkModel.clear()
                for (var i = 0; i < networksList.length; ++i)
                    dapNetworkModel.append({ "name" : networksList[i]})

//                console.info("Current network:", dapServiceController.CurrentNetwork)
            }

        }
    }

//    function rcvWallets(walletList)
//    {
//        if(walletList == "isEqual")
//            return


//        var jsonDocument = JSON.parse(walletList)

//        if(!jsonDocument)
//        {
//            dapModelWallets.clear()
//            return
//        }



//        dapModelWallets.clear()
//        dapModelWallets.append(jsonDocument)

//        console.log("rcvWallets", "currentWalletName", currentWalletName)

//        var nameIndex = -1

//        for (var i = 0; i < dapModelWallets.count; ++i)
//        {
//            if (dapModelWallets.get(i).name === currentWalletName)
//                nameIndex = i
//        }

//        console.log("rcvWallets", "nameIndex", nameIndex)

//        if (nameIndex >= 0)
//            currentWalletIndex = nameIndex

//        if (currentWalletIndex < 0 && dapModelWallets.count > 0)
//            currentWalletIndex = 0
//        if (dapModelWallets.count < 0)
//            currentWalletIndex = -1

//        modelWalletsUpdated()
//    }

//    function rcvWallet(wallet)
//    {
//        var jsonDocument = JSON.parse(wallet)

////        console.log("AAAAAAAAAAAAA", dapModelWallets.count, wallet)

//        if(!jsonDocument || (!jsonDocument.status && !jsonDocument.networks.length))
//        {
//            dapModelWallets.clear()
//            return
//        }


//        for (var i = 0; i < dapModelWallets.count; ++i)
//        {
//            if (dapModelWallets.get(i).name === jsonDocument.name)
//            {
//                dapModelWallets.set(i, jsonDocument)

//                return


////                dapModelWallets.get(i).status = jsonDocument.status

////                if(jsonDocument.status === "" || jsonDocument.status === "Active")
////                {
//////                    console.log(jsonDocument.networks)
////                    dapModelWallets.get(i).networks.clear()
////                    dapModelWallets.get(i).networks.append(jsonDocument.networks)
//////                    dapModelWallets.get(i).networks = jsonDocument.networks
//////                    console.log(dapModelWallets.get(i).networks)
////                }
//            }
//        }
//    }

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
//        console.log("rcvOpenOrders", rcvData)

        if(rcvData !== "isEqual")
        {
//            if (!simulationStock)
//                orderBookWorker.setBookModel(rcvData)

            var jsonDocument = JSON.parse(rcvData)
            dapModelXchangeOrders.clear()
            dapModelXchangeOrders.append(jsonDocument)
            modelXchangeOrdersUpdated()
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

                orderBookWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

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

                orderBookWorker.setTokenPair(token1Name, token2Name, tokenNetwork)

                modelPairsUpdated()
            }
        }
    }

//    function rcvTokenPriceHistory(rcvData)
//    {
////        console.log("rcvTokenPriceHistory", rcvData)

//        if(rcvData !== "")
//        {
//            if (!simulationStock)
//                candleChartWorker.setTokenPriceHistory(rcvData)

//            var jsonDocument = JSON.parse(rcvData)

////            print("rcvData", rcvData)
////            dapTokenPriceHistory.clear()
////            dapTokenPriceHistory.append(jsonDocument.history)
//        }
//    }

    function rcvStateNotify(isError, isFirst)
    {
        messagePopup.dapButtonCancel.visible = false
        messagePopup.dapButtonOk.textButton = "Ok"

        if(isError)
        {
            if(isFirst)
                messagePopup.smartOpen("Notify socket", qsTr("Lost connection to the Node. Reconnecting..."))
            console.warn("ERROR NOTIFY SOCKET")
            stateNotify = false
        }
        else
        {
            messagePopup.close()
            if(isFirst)
                console.info("CONNECT TO NOTIFY SOCKET")

            if(!stateNotify) //TODO with notify
                logicMainApp.requestToService("DapGetNetworksStateCommand")
            stateNotify = true
        }
    }

//    function getAllWalletHistory(index, update, isLastActions)
//    {

//        if (index < 0 || index >= dapModelWallets.count)
//            return

//        var network_array = ""

//        var name = dapModelWallets.get(index).name

//        var model = dapModelWallets.get(index).networks

//        if(model)
//        {
//            for (var i = 0; i < model.count; ++i)
//            {
//                network_array += model.get(i).name + ":"
//                network_array += model.get(i).address + ":"
//                network_array += name + "/"
//            }
//            requestToService("DapGetAllWalletHistoryCommand",
//                             network_array, update ? "true": "false", isLastActions ? "true": "false")
//        }
//    }

    function serializeWebSite()
    {
        var result = "";    // for save settings
        var blocklist = ""; // only blocked sites for service

        for(var i = 0; i < dapWebSites.count; i++) {
            var line = dapWebSites.get(i).site + "," + dapWebSites.get(i).enabled;
            result = result + line + ";";

            if(dapWebSites.get(i).enabled === false) blocklist = blocklist + dapWebSites.get(i).site + ";";
        }

        if(result.length > 0) {
            // remove last ';'
            result = result.slice(0,-1);
            blocklist = blocklist.slice(0,-1);

            notifyService("DapWebBlockList", blocklist);
        }

        return result;
    }

    function rcvWebConnectRequest(rcvData)
    {
        var data = JSON.parse(rcvData)
        console.log("[rcvWebConnectRequest] Received a signal from Web3")
        var isEqual = false
        //filtering equeal sites requests
        for(var i = 0; i < dapMessageBuffer.count; i++)
        {
            if(dapMessageBuffer.get(i).site === data[0]){
                isEqual = true
                break;
            }
        }

        var isContains = false;
        for(var j = 0; j < dapWebSites.count; j++)
        {
            if(dapWebSites.get(j).site === data[0])
            {
                isContains = true
                if(!dapWebSites.get(j).enabled)
                {
//                    var rcv = [false, data[1]]
                    notifyService("DapWebConnectRequest",false, data[1])
                    dapMessageLogBuffer.append({infoText: "The site " + data[0] + " requests permission to work with your wallet",
                                                date: logicMainApp.getDate("yyyy-MM-dd, hh:mm ap"),
                                                reply: "Denied"})
                    return
                }
            }
        }

        if(!isContains)
            dapWebSites.append({site:data[0],
                                enabled: true})

        if(!isEqual)
        {
            requestsMessageCounter++
            dapMessageBuffer.append({indexRequest: data[1],
                                     site: data[0],
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
                    webPopup.setDisplayText(isSingle, data[0], data[1])
                }
                if(!webPopup.isOpen)
                    webPopup.open()
            }
        }
    }

    function rcvNewVersion(currVer, data)
    {
        lastVersion = data.lastVersion
        hasUpdate = data.hasUpdate
        urlDownload = data.url

        messagePopupVersion.dapButtonCancel.visible = true
        messagePopupVersion.dapButtonOk.textButton = "Update"
        messagePopupVersion.dapButtonCancel.textButton = "Cancel"

        messagePopupVersion.smartOpenVersion(qsTr("Dashboard update"), currVer, lastVersion, "")
    }

    function rcvReplyVersion()
    {
        messagePopupVersion.dapButtonCancel.visible = false
        messagePopupVersion.dapButtonOk.textButton = "Ok"

        messagePopupVersion.smartOpenVersion(qsTr("Dashboard update"), "", "", qsTr("You have the latest version installed."))
    }

    function updateDashboard()
    {
        Qt.openUrlExternally(urlDownload);
//        dapServiceController.requestToService("DapVersionController", "update")
//        updatingDashboard("The update process has started.")
    }

//    function updatingDashboard(message)
//    {
//        messagePopupVersion.dapButtonCancel.visible = false
//        messagePopupVersion.dapButtonOk.textButton = "Ok"
//        messagePopupVersion.smartOpen("New version", qsTr(message))

//        delay(5000,function() {Qt.quit()} )
//    }

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

    function createRequestToService()
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

        return args;
    }

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

        app.requestToService(service, args);
    }

    function notifyService()
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

        app.notifyService(service, args);
    }
}
