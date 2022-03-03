import QtQuick 2.12

QtObject {

    property var  currentIndex: -1
    property var  prevIndex: -1
    property var  activePlugin: ""


    function createDapData(buffer)
    {
        var dapData = []

        for(var i = 0; i < buffer.length ; i++)
        {
            dapData.push(buffer[i])
        }

        return dapData
    }

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

    function returnCurrentNetwork(buffer)
    {
        if (!buffer)
            console.error("networksList is empty")
        else
        {
            if (buffer[0] === "[net]")
            {
                console.log("Current network: "+buffer[1])
                return buffer[1]
            }
            else
            {
                console.log("Current network: "+buffer[0])
                return buffer[0]
            }
        }
    }

    function rcvNetworksList(buffer, parent)
    {
        var dapModel = Qt.createQmlObject('import QtQuick 2.2; \
                ListModel {}',parent);

        var dapData = createDapData(buffer)

        var i = 0
        var net = -1

        while (i < Object.keys(buffer).length)
        {
            if (buffer[i] === "[net]")
            {
                ++i
                if (i >= Object.keys(buffer).length)
                    break

                ++net
                dapModel.append({ "name" : buffer[i],
                                      "chains" : []})

                print("[net]", buffer[i])

                ++i
                if (i >= Object.keys(buffer).length)
                    break

                while (i < Object.keys(buffer).length
                       && buffer[i] === "[chain]")
                {
                    ++i
                    if (i >= Object.keys(buffer).length)
                        break

                    dapModel.get(net).chains.append({"name": buffer[i]})

                    print("[chain]", buffer[i])

                    ++i
                    if (i >= Object.keys(buffer).length)
                        break
                }
            }
            else
                ++i
        }
        return dapModel
    }

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

    function initButtonsModel(buttonsModel, tabModel)
    {
        if(tabModel)
        {
            for (var j = 0; j < tabModel.count; ++j)
            {
                for (var k = 0; k < buttonsModel.length; ++k)
                {
                    if (tabModel.get(j).tag ===
                        buttonsModel[k].tag &&
                        tabModel.get(j).name ===
                        buttonsModel[k].name)
                    {
                        console.log(tabModel.get(j).tag,
                                    "show", tabModel.get(j).show)

                        buttonsModel[k].showTab = tabModel.get(j).show
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

}
