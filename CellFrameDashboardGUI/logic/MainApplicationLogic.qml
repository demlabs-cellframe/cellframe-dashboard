import QtQuick 2.12
import QtQml 2.12

QtObject {
    property var  currentIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    //wallets create param
    property bool restoreWalletMode: false
    property string currentTab: params.isMobile ? "" : mainScreenStack.currPage
    property string walletRecoveryType: "Nothing"
    //

    property string menuTabStates: ""
    property var networkArray: ""

    readonly property int autoUpdateInterval: 3000

    property bool stateNotify: true

    property string lastVersion
    property bool hasUpdate
    property string urlDownload


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
                                    bttnIco: "icon_certificates.png",
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
                                            bttnIco: "icon_certificates.png",
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

                dapServiceController.requestToService("DapGetNetworksStateCommand")
            }
            console.info("Current network: "+dapServiceController.CurrentNetwork)
        }
    }

    function rcvWallets(walletList)
    {
        if(!walletList.length)
        {
            dapModelWallets.clear()
            return
        }

        dapModelWallets.clear()

        for (var i = 0; i < walletList.length; ++i)
        {
            dapModelWallets.append({ "name" : walletList[i].Name,
                                  "icon" : walletList[i].Icon,
                                  "networks" : []})

            for (var n = 0; n < Object.keys(walletList[i].Networks).length; ++n)
            {
                dapModelWallets.get(i).networks.append({"name": walletList[i].Networks[n],
                      "address": walletList[i].findAddress(walletList[i].Networks[n]),
                      "chains": [],
                      "tokens": []})

                var chains = walletList[i].getChains(walletList[i].Networks[n])

                for (var c = 0; c < chains.length; ++c)
                    dapModelWallets.get(i).networks.get(n).chains.append({"name": chains[c]})

                for (var t = 0; t < Object.keys(walletList[i].Tokens).length; ++t)
                {
                    if(walletList[i].Tokens[t].Network === walletList[i].Networks[n])
                    {
                        dapModelWallets.get(i).networks.get(n).tokens.append(
                             {"name": walletList[i].Tokens[t].Name,
                              "full_balance": walletList[i].Tokens[t].FullBalance,
                              "balance_without_zeros": walletList[i].Tokens[t].BalanceWithoutZeros,
                              "datoshi": walletList[i].Tokens[t].Datoshi,
                              "network": walletList[i].Tokens[t].Network})
                    }
                }
            }
        }

        if (currentIndex < 0 && dapModelWallets.count > 0)
            currentIndex = 0
        if (dapModelWallets.count < 0)
            currentIndex = -1

        networkArray = ""

        if (currentIndex >= 0)
        {
            var model = dapModelWallets.get(currentIndex).networks

            for (var j = 0; j < model.count; ++j)
            {
                if (model.get(j).chains.count > 0)
                {
                    for (var k = 0; k < model.get(j).chains.count; ++k)
                    {
                        networkArray += model.get(j).name + ":"
                        networkArray += model.get(j).chains.get(k).name + "/"
                    }
                }
                else
                {
                    networkArray += model.get(j).name + ":"
                    networkArray += "zero" + "/"
                }
            }
        }
    }

    function rcvWallet(wallet)
    {
        if(!Object.keys(wallet.Networks).length)
        {
            dapModelWallets.clear()
            return
        }

        for (var i = 0; i < dapModelWallets.count; ++i)
        {
            if (dapModelWallets.get(i).name === wallet.Name)
            {
                dapModelWallets.get(i).networks.clear()

                for (var n = 0; n < Object.keys(wallet.Networks).length; ++n)
                {
                    dapModelWallets.get(i).networks.append({"name": wallet.Networks[n],
                          "address": wallet.findAddress(wallet.Networks[n]),
                          "chains": [],
                          "tokens": []})

                    var chains = wallet.getChains(wallet.Networks[n])

                    for (var c = 0; c < chains.length; ++c)
                        dapModelWallets.get(i).networks.get(n).chains.append({"name": chains[c]})

                    for (var t = 0; t < Object.keys(wallet.Tokens).length; ++t)
                    {
                        if(wallet.Tokens[t].Network === wallet.Networks[n])
                        {
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": wallet.Tokens[t].Name,
                                  "full_balance": wallet.Tokens[t].FullBalance,
                                  "balance_without_zeros": wallet.Tokens[t].BalanceWithoutZeros,
                                  "datoshi": wallet.Tokens[t].Datoshi,
                                  "network": wallet.Tokens[t].Network})
                        }
                    }
                }

            }
        }
    }

    function rcvOrders(orderList)
    {
        dapModelOrders.clear()
        for (var i = 0; i < orderList.length; ++i)
            dapModelOrders.append({ "index" : orderList[i].Index,
                                  "location" : orderList[i].Location,
                                  "network" : orderList[i].Network,
                                  "node_addr" : orderList[i].AddrNode,
                                  "price" : orderList[i].TotalPrice})

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
            console.info("CONNECT SOCKET")
                if(!stateNotify) //TODO with notify
                    dapServiceController.requestToService("DapGetNetworksStateCommand")
            stateNotify = true
        }
    }

    function getAllWalletHistory(index)
    {
        if (index < 0 || index >= dapModelWallets.count)
            return

        var network_array = ""

        var model = dapModelWallets.get(index).networks

        for (var i = 0; i < model.count; ++i)
        {
            if (model.get(i).chains.count > 0)
            {
                for (var j = 0; j < model.get(i).chains.count; ++j)
                {
                    network_array += model.get(i).name + ":"
                    network_array += model.get(i).chains.get(j).name + ":"
                    network_array += model.get(i).address + "/"
                }
            }
            else
            {
                network_array += model.get(i).name + ":"
                network_array += "zero" + ":"
                network_array += model.get(i).address + "/"
            }
        }
        dapServiceController.requestToService("DapGetAllWalletHistoryCommand", network_array);
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
}
