import QtQuick 2.12

QtObject {

    property var  currentIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""
    property var currentNetwork: -1

    //wallets create param
    property bool restoreWalletMode: false
    property string currentTab
    property string walletRecoveryType: "Nothing"
    //


    function createDapData(buffer)
    {
        var dapData = []

        for(var i = 0; i < buffer.length ; i++)
        {
            dapData.push(buffer[i])
        }

        return dapData
    }

    /////////////PLUGINS
    function rcvPluginList(buffer, parent)
    {

        var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
                ListModel {}',parent);

        var dapData = createDapData(buffer)

        for(var q = 0; q < dapData.length; q++)
        {
            console.log("Plugin name: "+ dapData[q][0] + " - Loaded")
            dapModel.append({"name" : dapData[q][0],
                             "path" : dapData[q][1],
                             "status" : dapData[q][2],
                             "verifed" : dapData[q][3]})
        }
        return dapModel
    }

    /////////////ORDERS
    function rcvOrderList(buffer, parent)
    {
        var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
                ListModel {}',parent);

        var dapData = createDapData(buffer)

        for(var q = 0; q < dapData.length; q++)
        {
            console.log("Order index: "+ dapData[q].Index + " Network "+ dapData[q].Network + " - Loaded")

            dapModel.append({ "index" : dapData[q].Index,
                                "location" : dapData[q].Location,
                                "network" : dapData[q].Network,
                                "node_addr" : dapData[q].AddrNode,
                                "price" : dapData[q].TotalPrice})
        }
        return dapModel
    }

    /////////////WALLETS
    function rcvWalletList(buffer, parent)
    {
        var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
                ListModel {}',parent);

        var dapData = createDapData(buffer)

        for (var i = 0; i < dapData.length; ++i)
        {
            console.log("Wallet name: "+ dapData[i].Name)
            dapModel.append({ "name" : dapData[i].Name,
                                  "icon" : dapData[i].Icon,
                                  "networks" : []})
            console.log("Networks number: "+Object.keys(dapData[i].Networks).length)
            for (var n = 0; n < Object.keys(dapData[i].Networks).length; ++n)
            {
                console.log("Network name: "+dapData[i].Networks[n])
                print("address", dapData[i].findAddress(dapData[i].Networks[n]))
                print("chains", dapData[i].getChains(dapData[i].Networks[n]))

                dapModel.get(i).networks.append({"name": dapData[i].Networks[n],
                      "address": dapData[i].findAddress(dapData[i].Networks[n]),
                      "chains": [],
                      "tokens": []})

                var chains = dapData[i].getChains(dapData[i].Networks[n])

                console.log("chains", chains)

                for (var c = 0; c < chains.length; ++c)
                {
                    print(chains[c])
                    dapModel.get(i).networks.get(n).chains.append({"name": chains[c]})
                }

                console.log("dapModelWallets.get(i).networks.get(n).chains.count",
                            dapModel.get(i).networks.get(n).chains.count)

                console.log("Tokens.length:", Object.keys(dapData[i].Tokens).length)
                for (var t = 0; t < Object.keys(dapData[i].Tokens).length; ++t)
                {
                    if(dapData[i].Tokens[t].Network === dapData[i].Networks[n])
                    {
                        console.log(dapData[i].Tokens[t].Network + " === " + dapData[i].Networks[n])
                        dapModel.get(i).networks.get(n).tokens.append(
                             {"name": dapData[i].Tokens[t].Name,
                              "full_balance": dapData[i].Tokens[t].FullBalance,
                              "balance_without_zeros": dapData[i].Tokens[t].BalanceWithoutZeros,
                              "datoshi": dapData[i].Tokens[t].Datoshi,
                              "network": dapData[i].Tokens[t].Network})
                    }
                }
            }
        }

        if (currentIndex < 0 && dapModel.count > 0)
            currentIndex = 0
        if (dapModel.count < 0)
            currentIndex = -1

        return dapModel
    }

    /////////////NETWORKS
    function rcvNetworksList(buffer, parent)
    {
        var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
                ListModel {}',parent);

        if (!buffer.length)
            console.error("networksList is empty")
        else
        {
            if(currentNetwork === -1)
            {
                dapServiceController.setCurrentNetwork(buffer[0]);
                dapServiceController.setIndexCurrentNetwork(0);
                currentNetwork = dapServiceController.IndexCurrentNetwork
            }
            else
            {
                dapServiceController.setCurrentNetwork(buffer[currentNetwork]);
                dapServiceController.setIndexCurrentNetwork(currentNetwork);
            }

            dapModel.clear()
            for (var i = 0; i < buffer.length; ++i)
                dapModel.append({ "name" : buffer[i]})

        }
        console.info("Current network: "+dapServiceController.CurrentNetwork)

        return dapModel
    }

    /////////////HISTORY
    function getWalletHistory(index, modelWalelts)
    {
        var counter = 0

        if (index < 0 || index >= modelWalelts.count)
            return counter

        var model = modelWalelts.get(index).networks
        var name = modelWalelts.get(index).name

        for (var i = 0; i < model.count; ++i)
        {
            var network = model.get(i).name
            var address = model.get(i).address

            if (model.get(i).chains.count > 0)
            {
                for (var j = 0; j < model.get(i).chains.count; ++j)
                {
                    var chain = model.get(i).chains.get(j).name

                    dapServiceController.requestToService("DapGetWalletHistoryCommand",
                        network, chain, address, name);

                    ++counter
                }
            }
            else
            {
                dapServiceController.requestToService("DapGetWalletHistoryCommand",
                    network, "zero", address, name);

                ++counter
            }
        }

        return counter
    }

    //////////////NETWORKS STATE

    function isEqualList(currModel, data)
    {
        if (currModel.count === data.length) {
            for (var i=0; i<currModel.count; ++i) {
                if (currModel.get(i).name !== data[i].name) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }

    function rcvNetworksStatesList(model, buffer)
    {
        for (var i = 0; i < buffer.length; ++i)
        {
            model.append({ "name" : buffer[i].name,
                                            "networkState" : buffer[i].networkState,
                                            "targetState" : buffer[i].targetState,
                                            "stateColor" : buffer[i].stateColor,
                                            "errorMessage" : buffer[i].errorMessage,
                                            "linksCount" : buffer[i].linksCount,
                                            "activeLinksCount" : buffer[i].activeLinksCount,
                                            "nodeAddress" : buffer[i].nodeAddress})
        }
    }

    function updateContent(currMdel, newData)
    {
        if (globalLogic.isEqualList(currMdel, newData)) {
            for (var i=0; i<currMdel.count; ++i) {
                if (currMdel.get(i).name !== newData[i].name)
                    currMdel.set(i, {"name": newData[i].name})
                if (currMdel.get(i).networkState !== newData[i].networkState)
                    currMdel.set(i, {"networkState": newData[i].networkState})
                if (currMdel.get(i).targetState !== newData[i].targetState)
                    currMdel.set(i, {"targetState": newData[i].targetState})
                if (currMdel.get(i).stateColor !== newData[i].stateColor)
                    currMdel.set(i, {"stateColor": newData[i].stateColor})
                if (currMdel.get(i).errorMessage !== newData[i].errorMessage)
                    currMdel.set(i, {"errorMessage": newData[i].errorMessage})
                if (currMdel.get(i).linksCount !== newData[i].linksCount)
                    currMdel.set(i, {"linksCount": newData[i].linksCount})
                if (currMdel.get(i).activeLinksCount !== newData[i].activeLinksCount)
                    currMdel.set(i, {"activeLinksCount": newData[i].activeLinksCount})
                if (currMdel.get(i).nodeAddress !== newData[i].nodeAddress)
                    currMdel.set(i, {"nodeAddress": newData[i].nodeAddress})
            }
        }
    }

    function updateContentInSpecified(data, dataModel)
    {
        if (data.name !== dataModel.name)
            data.name = dataModel.name
        if (data.networkState !== dataModel.networkState)
            data.networkState = dataModel.networkState
        if (data.stateColor !== dataModel.stateColor)
            data.stateColor = dataModel.stateColor
        if (data.errorMessage !== dataModel.errorMessage)
            data.errorMessage = dataModel.errorMessage
        if (data.targetState !== dataModel.targetState)
            data.targetState = dataModel.targetState
        if (data.linksCount !== dataModel.linksCount)
            data.linksCount = dataModel.linksCount
        if (data.activeLinksCount !== dataModel.activeLinksCount)
            data.activeLinksCount = dataModel.activeLinksCount
        if (data.nodeAddress !== dataModel.nodeAddress)
            data.nodeAddress = dataModel.nodeAddress
    }

    /////////////TABS
    function initButtonsModel(buttonsModel, tabModel)
    {
        if(tabModel)
        {
            for (var j = 0; j < tabModel.count; ++j)
            {
                for (var k = 0; k < buttonsModel.count; ++k)
                {
                    if (tabModel.get(j).tag ===
                        buttonsModel.get(k).tag &&
                        tabModel.get(j).name ===
                        buttonsModel.get(k).name)
                    {
                        console.log(tabModel.get(j).tag,
                                    "show", tabModel.get(j).show)

                        buttonsModel.get(k).showTab = tabModel.get(j).show
                        break
                    }
                }
            }
        }
        return buttonsModel
    }

    function loadSettingsInTabs(tabModel, settingsModel)
    {
        if(tabModel)
        {
            for (var i = 0; i < settingsModel.length; ++i)
            {
                for (var j = 0; j < tabModel.count; ++j)
                {
                    if (settingsModel[i].tag ===
                            tabModel.get(j).tag &&
                            tabModel.get(j).name ===
                            settingsModel[i].name)
                    {
                        tabModel.get(j).show = settingsModel[i].show
                        break
                    }
                }
            }
        }
        return tabModel
    }

    function updateMenuTabStatus(modelMenu, modelApps)
    {
        var datamodel = []
        for (var i = 0; i < modelMenu.count; ++i)
            datamodel.push(modelMenu.get(i))

        for (var i = 0; i < modelApps.count; ++i)
            datamodel.push(modelApps.get(i))

        return JSON.stringify(datamodel)
    }
}
