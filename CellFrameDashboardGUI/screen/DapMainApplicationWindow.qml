import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3

import "qrc:/screen"
import "qrc:/resources/QML"
import "qrc:/screen/desktop/Dashboard"
import "qrc:/screen/desktop/Exchange"
import "qrc:/screen/desktop/Certificates"
//import "qrc:/screen/desktop/NetworksPanel"
import "qrc:/screen/desktop/RightPanel"
import "qrc:/screen/desktop/Settings"
import "desktop/SettingsWallet.js" as SettingsWallet
import "../resources/theme" as Theme
import "qrc:/widgets"


Rectangle {
    id: dapMainWindow

    ///@detalis Path to the dashboard tab.
    readonly property string dashboardScreenPath: "qrc:/screen/" + device + "/Dashboard/DapDashboardTab.qml"
    ///@detalis Path to the dashboard tab.
    readonly property string walletScreenPath: "qrc:/screen/" + device + "/Wallet/DapWalletTab.qml"
    ///@detalis Path to the exchange tab.
    readonly property string exchangeScreenPath: "qrc:/screen/" + device + "/Exchange/DapExchangeTab.qml"
    ///@detalis Path to the history tab.
    readonly property string historyScreenPath: "qrc:/screen/" + device + "/History/DapHistoryTab.qml"
    ///@detalis Path to the VPN service tab.
//    readonly property string vpnServiceScreenPath: "qrc:/screen/" + device + "/VPNService/DapVPNServiceTab.qml"
    readonly property string vpnServiceScreenPath: "qrc:/screen/" + device + "/VPNService_New/DapVPNServiceTab.qml"
    ///@detalis Path to the VPN client tab.
    readonly property string vpnClientScreenPath: "qrc:/screen/" + device + "/VPNClient/DapVpnClientTab.qml"
    ///@detalis Path to the settings tab.
    readonly property string settingsScreenPath: "qrc:/screen/" + device + "/Settings/DapSettingsTab.qml"
    ///@detalis Path to the logs tab.
    readonly property string logsScreenPath: "qrc:/screen/" + device + "/Logs/DapLogsTab.qml"
    ///@detalis Path to the console tab.
    readonly property string consoleScreenPath: "qrc:/screen/" + device + "/Console/DapConsoleTab.qml"
    ///@detalis Path to the certificates tab.
    readonly property string certificatesScreenPath: "qrc:/screen/" + device + "/Certificates/DapCertificatesMainPage.qml"
    ///@detalis Path to the tokens tab.
    readonly property string tokensScreenPath: "qrc:/screen/" + device + "/Tokens/DapTokensTab.qml"
     ///@detalis Path to the plugins tab.
    readonly property string pluginsScreen: "qrc:/screen/" + device + "/Plugins/Plugin/DapApp.qml"
    ///@detalis Path to the plugins tab.
   readonly property string miniGameScreen: "qrc:/screen/" + device + "/Plugins/MiniGame/MiniGame.qml"
    ///@detalis Path to the dApps tab.
    readonly property string dAppsScreen: "qrc:/screen/" + device + "/dApps/DapAppsTab.qml"


    readonly property string underConstructionsScreenPath: "qrc:/screen/" + device + "/UnderConstructions.qml"

    readonly property string testScreenPath: "qrc:/screen/" + device + "/Test/TestPage.qml"

    ///@details dapMainFonts Project font loader
    readonly property QtObject dapMainFonts: DapFontRoboto {}
//    readonly property QtObject dapQuicksandFonts: DapFontQuicksand {}
    property alias dapQuicksandFonts: quicksandFonts
    DapFontQuicksand {
        id: quicksandFonts
    }

    Theme.Dark {id: darkTheme}
    Theme.Light {id: lightTheme}

    ListModel{
        id:themes
        Component.onCompleted:
        {
            append({name:qsTr("Dark theme"),
                    source:darkTheme
                   })
        }
    }
    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme

    signal menuTabChanged()
    signal pluginsTabChanged(var auto, var removed, var name)

    property alias dapModelMenuTabStates: modelMenuTabStates

    // Menu bar tab model
    ListModel
    {
        id: modelMenuTabStates
        ListElement { tag: "Tokens"
            name: qsTr("Tokens")
            show: true }
        ListElement { tag: "Certificates"
            name: qsTr("Certificates")
            show: true }
        ListElement { tag: "VPN service"
            name: qsTr("VPN service")
            show: true }
        ListElement { tag: "Console"
            name: qsTr("Console")
            show: true }
        ListElement { tag: "Logs"
            name: qsTr("Logs")
            show: true }
        ListElement { tag: "dApps"
            name: qsTr("dApps")
            show: true }
    }

    property string menuTabStates: ""

    Settings {
      property alias menuTabStates: dapMainWindow.menuTabStates
    }

    ListModel
    {
        id:modelAppsTabStates
    }

    Connections
    {
        onMenuTabChanged:
        {
            console.log("onMenuTabChanged")
            updateMenuTabStatus()
        }
    }

    Connections
    {
        onPluginsTabChanged:
        {
            if(auto)
            {
                for(var i = 0; i < modelAppsTabStates.count; i++)
                {
                    modelMenuTab.append({name: qsTr(modelAppsTabStates.get(i).name),
                                        tag: modelAppsTabStates.get(i).tag,
                                        page: modelAppsTabStates.get(i).path,
                                        normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                                        hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                                        showTab: modelAppsTabStates.get(i).show})
                }
            }
            else
            {
                var index;
                if(removed)
                {
                    for(var i = 0; i < modelMenuTab.count; i++)
                    {

                        if(modelMenuTab.get(i).name === name)
                        {
                            modelMenuTab.remove(i);
                            break;
                        }
                    }
                }
                else
                {
                    for(var i = 0; i < modelAppsTabStates.count; i++)
                    {
                        if(modelAppsTabStates.get(i).name === name)
                        {
                            modelMenuTab.append({name: qsTr(modelAppsTabStates.get(i).name),
                                                tag: modelAppsTabStates.get(i).tag,
                                                page: modelAppsTabStates.get(i).path,
                                                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                                                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                                                showTab: modelAppsTabStates.get(i).show})
                            break;
                        }
                    }
                }
            }
            updateMenuTabStatus()
        }
    }

    function updateMenuTabStatus()
    {
        var datamodel = []
        for (var i = 0; i < modelMenuTabStates.count; ++i)
        {
            datamodel.push(modelMenuTabStates.get(i))
            console.log(modelMenuTabStates.get(i).tag,
                            "show", modelMenuTabStates.get(i).show)
        }

        for (var i = 0; i < modelAppsTabStates.count; ++i)
        {
            datamodel.push(modelAppsTabStates.get(i))
            console.log(modelAppsTabStates.get(i).tag,
                            "show", modelAppsTabStates.get(i).show)
        }

        menuTabStates = JSON.stringify(datamodel)
    }

    //for test
//    property string pathTheme: currThemeVal ? "BlackTheme":"WhiteTheme"
    property string pathTheme: "BlackTheme"

    property string currentTab: stackViewTabs.source

    property bool restoreWalletMode: false

    property string walletRecoveryType: "Nothing"




    color:currTheme.backgroundPanel

    // The horizontal location of the virtual menu column and tab view loader
    Row
    {
        id: rowMainWindow
//            height: 754

        anchors {
            left: parent.left;
            top: parent.top;
            right: parent.right;
            bottom: footer.top
            bottomMargin: 6 * pt
        }

        // Virtual logo column frame and menu bar
        Column
        {
            id: columnMenuTab
            height: rowMainWindow.height
            width: 183 * pt
            spacing: 0
            // Logotype widget
            Item
            {
                id: logotype
                width: parent.width * pt
                height: 60 * pt

                Rectangle
                {
                    id: frameLogotype
                    anchors.fill: parent
                    color:currTheme.backgroundPanel

                    DapImageLoader{
                        innerWidth: 114 * pt
                        innerHeight: 24 * pt
                        source: "qrc:/resources/icons/" + pathTheme + "/cellframe-logo-dashboard.png"

//                        anchors.fill: parent
                        anchors.left: parent.left
                        anchors.leftMargin: 23*pt
//                        anchors.bottom: parent.bottom
//                        anchors.bottomMargin: 18.91*pt
                        anchors.top: parent.top
                        anchors.topMargin: 19.86 * pt
//                        anchors.rightMargin: 48 * pt

                        //anchors.topMargin: 18 * pt
                        //visible: false
                    }
                    ToolTip
                    {
                        id:toolTip
                        visible: area.containsMouse? true : false
                        text: "https://cellframe.net"

                        contentItem: Text {
                                text: toolTip.text
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                color: currTheme.textColor
                            }

                        background: Rectangle{color:currTheme.backgroundPanel}
                    }
                    MouseArea
                    {
                        id:area
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked:
                        {
                            Qt.openUrlExternally(toolTip.text);

                        }
                    }
                }
            }
            // Menu bar widget
            Item
            {
                id: menuWidget
                width: 183 * pt
                height: columnMenuTab.height - logotype.height
                //hide left radius element
                Rectangle
                {
                    id: squareRect
                    width: menuTabWidget.radius
                    color: currTheme.backgroundPanel
                    anchors.bottom: menuTabWidget.bottom
                    anchors.left: menuTabWidget.left
                    anchors.top: menuTabWidget.top
                }
                //hide top radius element
                Rectangle{
                    height: currTheme.radiusRectangle
                    anchors.top:parent.top
                    anchors.right: parent.right
                    anchors.left: parent.left
                    color: currTheme.backgroundPanel
                }

                data: DapAbstractMenuTabWidget
                {
                    color:currTheme.backgroundPanel
                    radius: currTheme.radiusRectangle


//                        anchors.leftMargin: -8*pt

                    onPathScreenChanged:
                    {
                        stackViewTabs.setSource(Qt.resolvedUrl(this.pathScreen))
                    }
                    id: menuTabWidget
                    anchors.fill: parent
                    widthItemMenu: 186*pt
                    heightItemMenu: 52 * pt
                    normalColorItemMenu: currTheme.backgroundPanel
                    selectColorItemMenu: "transparent"
                    widthIconItemMenu: 16 * pt
                    heightIconItemMenu: 16 * pt
                    dapMenuWidget.model: modelMenuTab
                    normalFont: "Quicksand"
                    selectedFont: "Quicksand"
                }
            }
        }

        // Screen downloader widget
        Item
        {
            id: screens
//                data: dabScreensWidget
            height: rowMainWindow.height
            width: rowMainWindow.width - columnMenuTab.width
            Loader
            {
                id: stackViewTabs
                anchors.fill: parent
                clip: true
                source: dashboardScreenPath
            }
        }
    }

//    DapNetworkPopup
//    {
//        id: networkPanelPopup
//    }

    property var dapWallets: []
    property var dapOrders: []
    property var dapPlugins: []
    property var dapNetworks: []

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()
    signal modelPluginsUpdated()

    signal keyPressed(var event)
    Keys.onPressed: keyPressed(event)


    //open in module visible root context, only for work
    Component{
        DapCertificatesMainPage { }
    }

    DapMessagePopup{id: messagePopup}
    property bool stateNotify: true

    ListModel
    {
        id: dapNetworkModel
    }

    ListModel
    {
        id: dapModelWallets
    }
    ListModel
    {
        id: dapModelOrders
    }
    ListModel
    {
        id: dapModelPlugins
    }

    ListModel 
    {
        id: modelMenuTab

        Component.onCompleted:
        {
            append({
                name: qsTr("Wallet"),
                tag: "Wallet",
                page: dashboardScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_wallet.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_wallet.png",
                showTab: true
            })

//TODO: The tab is disabled until the functional part is implemented
            append ({
                name: qsTr("Exchange"),
                tag: "Exchange",
                page: underConstructionsScreenPath, //TODO: here should be: exchangeScreenPath,
//                page: exchangeScreenPath, //TODO: here should be: exchangeScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_exchange.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_exchange.png",
                showTab: true
            })
    
            append ({
                name: qsTr("TX explorer"),
                tag: "TX Explorer",
                page: historyScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_history.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_history.png",
                showTab: true
            })

            append ({
                name: qsTr("Certificates"),
                tag: "Certificates",
                page: certificatesScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_certificates.png",
                showTab: true
            })

            append ({
                name: qsTr("Tokens"),
                tag: "Tokens",
                page: underConstructionsScreenPath, //TODO: add screen for "Tokens" tab
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_tokens.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_tokens.png",
                showTab: true
            })

            append ({
                name: qsTr("VPN client"),
                tag: "VPN client",
                page: underConstructionsScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/vpn-client_icon.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/vpn-client_icon.png",
                showTab: true
            })

            append ({
                name: qsTr("VPN service"),
                tag: "VPN service",
                page: vpnServiceScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_vpn.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_vpn.png",
                showTab: true
            })

            append ({
                name: qsTr("Console"),
                tag: "Console",
                page: consoleScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_console.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_console.png",
                showTab: true
            })

            append ({
                name: qsTr("Logs"),
                tag: "Logs",
                page: logsScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_logs.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_logs.png",
                showTab: true
            })

            append ({
                name: qsTr("dApps"),
                tag: "dApps",
                page: dAppsScreen,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
                showTab: true
            })

            append ({
                name: qsTr("Settings"),
                tag: "Settings",
                page: settingsScreenPath,
                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_settings.png",
                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_settings.png",
                showTab: true
            })

//            append ({
//                name: qsTr("Plugin"),
//                tag: "Plugins",
//                page: pluginsScreen,
//                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
//                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
//                showTab: true
//            })

//            append ({
//                name: qsTr("MiniGame"),
//                tag: "Plugins",
//                page: miniGameScreen,
//                normalIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
//                hoverIcon: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/icon_daaps.png",
//                showTab: true
//            })

            //Test elements page for debug
//            append ({
//                name: qsTr("Test"),
//                tag: "Test",
//                page: testScreen,
//                normalIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
//                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
//                showTab: true
//            })

            for (var j = 0; j < modelMenuTabStates.count; ++j)
            {
                for (var k = 0; k < modelMenuTab.count; ++k)
                {
                    if (modelMenuTabStates.get(j).tag ===
                        modelMenuTab.get(k).tag)
                    {
                        console.log(modelMenuTabStates.get(j).tag,
                                    "show", modelMenuTabStates.get(j).show)

                        modelMenuTab.get(k).showTab = modelMenuTabStates.get(j).show
                        break
                    }
                }
            }

            for (var j = 0; j < modelAppsTabStates.count; ++j)
            {
                for (var k = 0; k < modelMenuTab.count; ++k)
                {
                    if (modelAppsTabStates.get(j).tag ===
                        modelMenuTab.get(k).tag &&
                        modelAppsTabStates.get(j).name ===
                        modelMenuTab.get(k).name)
                    {
                        console.log(modelAppsTabStates.get(j).tag,
                                    "show", modelAppsTabStates.get(j).show)

                        modelMenuTab.get(k).showTab = modelAppsTabStates.get(j).show
                        break
                    }
                }
            }
            pluginsTabChanged(true,false,"")
        }
    }
//    //Main Shadow
    DropShadow {
            anchors.fill: parent
            horizontalOffset: currTheme.hOffset
            verticalOffset: currTheme.vOffset
            radius: currTheme.radiusShadow
            color: currTheme.shadowColor
            source: columnMenuTab
            spread: 0.1
            smooth: true
        }

    Component.onCompleted:
    {
//        dapServiceController.requestToService("DapGetListNetworksCommand", "chains")
        dapServiceController.requestToService("DapGetNetworksStateCommand")
        pluginsManager.getListPlugins();
//        dapServiceController.requestToService("DapGetWalletsInfoCommand")

        if (menuTabStates)
        {
            console.log("loading menuTabStates", menuTabStates)

            var datamodel = JSON.parse(menuTabStates)

            for (var i = 0; i < datamodel.length; ++i)
            {
                for (var j = 0; j < modelMenuTabStates.count; ++j)
                {
                    if (datamodel[i].tag ===modelMenuTabStates.get(j).tag)
                    {
                        modelMenuTabStates.get(j).show = datamodel[i].show
    //                      console.log(datamodel[i].tag, datamodel[i].show,
    //                          modelMenuTabStates.get(j).tag, modelMenuTabStates.get(j).show)
                        break
                    }
                }
            }
            for (var i = 0; i < datamodel.length; ++i)
            {
                for (var j = 0; j < modelAppsTabStates.count; ++j)
                {
                    if (datamodel[i].tag ===
                            modelAppsTabStates.get(j).tag &&
                            modelAppsTabStates.get(j).name ===
                            datamodel[i].name)
                    {
                        modelAppsTabStates.get(j).show = datamodel[i].show
                        break
                    }
                }
            }

        }
    }

    Connections
    {
        target: dapServiceController

        onNetworksListReceived:
        {
//            console.log("Networks list received")

            if (!networksList.length)
                console.error("networksList is empty")
            else
            {
                if(SettingsWallet.currentNetwork === -1)
                {
                    dapServiceController.setCurrentNetwork(networksList[0]);
                    dapServiceController.setIndexCurrentNetwork(0);
                    SettingsWallet.currentNetwork = dapServiceController.IndexCurrentNetwork
                }
                else
                {
                    dapServiceController.setCurrentNetwork(networksList[SettingsWallet.currentNetwork]);
                    dapServiceController.setIndexCurrentNetwork(SettingsWallet.currentNetwork);
                }


                dapNetworkModel.clear()
                for (var i = 0; i < networksList.length; ++i)
                {
                    dapNetworkModel.append({ "name" : networksList[i]})
//                    console.info("Name net: " + dapNetworkModel.get(i).name)
                }
            }
            console.info("Current network: "+dapServiceController.CurrentNetwork)

//            console.info("networksList is received")

//            var i = 0
//            var net = -1

//            while (i < Object.keys(networksList).length)
//            {
//                if (networksList[i] === "[net]")
//                {
//                    ++i
//                    if (i >= Object.keys(networksList).length)
//                        break

//                    ++net
//                    dapNetworkModel.append({ "name" : networksList[i],
//                                          "chains" : []})

//                    print("[net]", networksList[i])

//                    ++i
//                    if (i >= Object.keys(networksList).length)
//                        break

//                    while (i < Object.keys(networksList).length
//                           && networksList[i] === "[chain]")
//                    {
//                        ++i
//                        if (i >= Object.keys(networksList).length)
//                            break

//                        dapNetworkModel.get(net).chains.append({"name": networksList[i]})

//                        print("[chain]", networksList[i])

//                        ++i
//                        if (i >= Object.keys(networksList).length)
//                            break
//                    }
//                }
//                else
//                    ++i
//            }

//            for(var n=0; n < Object.keys(networksList).length; ++n)
//            {
//                dapNetworkModel.append({name: networksList[n]})
//            }
        }

        onWalletsReceived:
        {
            dapWallets.splice(0,dapWallets.length)
            dapModelWallets.clear()
            console.log("walletList.length =", walletList.length)
            console.log("dapWallets.length =", dapWallets.length)
            console.log("dapModelWallets.count =", dapModelWallets.count)

            for (var q = 0; q < walletList.length; ++q)
            {
                dapWallets.push(walletList[q])
            }

            for (var i = 0; i < dapWallets.length; ++i)
            {
                console.log("Wallet name: "+ dapWallets[i].Name)
                dapModelWallets.append({ "name" : dapWallets[i].Name,
                                      "icon" : dapWallets[i].Icon,
                                      "networks" : []})
                console.log("Networks number: "+Object.keys(dapWallets[i].Networks).length)
                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
                {
                    console.log("Network name: "+dapWallets[i].Networks[n])
                    print("address", dapWallets[i].findAddress(dapWallets[i].Networks[n]))
                    print("chains", dapWallets[i].getChains(dapWallets[i].Networks[n]))

                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                          "chains": [],
                          "tokens": []})

                    var chains = dapWallets[i].getChains(dapWallets[i].Networks[n])

                    console.log("chains", chains)

                    for (var c = 0; c < chains.length; ++c)
                    {
                        print(chains[c])
                        dapModelWallets.get(i).networks.get(n).chains.append({"name": chains[c]})
                    }

                    console.log("dapModelWallets.get(i).networks.get(n).chains.count",
                                dapModelWallets.get(i).networks.get(n).chains.count)

                    console.log("Tokens.length:", Object.keys(dapWallets[i].Tokens).length)
                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                            console.log(dapWallets[i].Tokens[t].Network + " === " + dapWallets[i].Networks[n])
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": dapWallets[i].Tokens[t].Name,
                                  "full_balance": dapWallets[i].Tokens[t].FullBalance,
                                  "balance_without_zeros": dapWallets[i].Tokens[t].BalanceWithoutZeros,
                                  "datoshi": dapWallets[i].Tokens[t].Datoshi,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }
                }
            }

            if (SettingsWallet.currentIndex < 0 && dapModelWallets.count > 0)
                SettingsWallet.currentIndex = 0
            if (dapModelWallets.count < 0)
                SettingsWallet.currentIndex = -1

            modelWalletsUpdated();


            //Show orders for debug
//            for (var e = 0; e < 10; ++e)
//            {
//                dapModelOrders.append({ "index" : e+1,
//                                      "location" : "wqe",
//                                      "network" : "sad",
//                                      "node_addr" : "213",
//                                      "price" : "1234515"})
//            }
//            modelOrdersUpdated();
        }
        onOrdersReceived:
        {
//            console.log("Orders len " + orderList.length)
//            console.log("DapOrders len " + dapOrders.length)
//            console.log("DapModelOrders len " + dapModelOrders.count)
            dapOrders.splice(0,dapOrders.length)
            dapModelOrders.clear()
            for (var q = 0; q < orderList.length; ++q)
            {
                dapOrders.push(orderList[q])
            }
            for (var i = 0; i < dapOrders.length; ++i)
            {
                console.log("Order index: "+ dapOrders[i].Index + " Network "+ dapOrders[i].Network + " - Loaded")
                dapModelOrders.append({ "index" : dapOrders[i].Index,
                                      "location" : dapOrders[i].Location,
                                      "network" : dapOrders[i].Network,
                                      "node_addr" : dapOrders[i].AddrNode,
                                      "price" : dapOrders[i].TotalPrice})
//                console.log("Price : " + dapOrders[i].TotalPrice)
//                console.log("Network : "+ dapOrders[i].Network)
            }
            modelOrdersUpdated();
        }

        onSignalStateSocket:
        {
            if(isError)
            {
                if(isFirst)
                    messagePopup.open()
                console.warn("ERROR SOCKET")
                stateNotify = false
            }
            else
            {
                messagePopup.close()
                console.info("CONNECT SOCKET")
                stateNotify = true
            }
        }
    }

    Connections{
        target: pluginsManager
        onRcvListPlugins:
        {
            dapPlugins.splice(0,dapPlugins.length)
            dapModelPlugins.clear()

            for(var i = 0; i < m_pluginsList.length ; i++)
            {
                dapPlugins.push(m_pluginsList[i])
            }
            for(var q = 0; q < dapPlugins.length; q++)
            {
                console.log("Plugin name: "+ dapPlugins[q][0] + " - Loaded")
                dapModelPlugins.append({"name" : dapPlugins[q][0],
                                        "path" : dapPlugins[q][1],
                                        "status" : dapPlugins[q][2],
                                        "verifed" : dapPlugins[q][3]})
            }
            modelPluginsUpdated()
            updateModelAppsTab()
        }
    }

    // function for DapLastActionsRightPanel.qml and DapHistoryTab.qml
    function getWalletHistory(index)
    {
        var counter = 0

        if (index < 0 || index >= dapModelWallets.count)
            return counter

        var model = dapModelWallets.get(index).networks
        var name = dapModelWallets.get(index).name

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

    function updateModelAppsTab() //create model apps from left menu tab
    {
        if(modelAppsTabStates.count)
        {
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                var indexCreate;
                for(var j = 0; j < modelAppsTabStates.count; j++)
                {
                    if(dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name && dapModelPlugins.get(i).status !== "1")
                    {

                        pluginsTabChanged(false, true, modelAppsTabStates.get(j).name)
                        modelAppsTabStates.remove(j);
                        j--;
                    }
                    else if(dapModelPlugins.get(i).status === "1" && dapModelPlugins.get(i).name !== modelAppsTabStates.get(j).name)
                    {
                        indexCreate = i;
                    }
                    else if(dapModelPlugins.get(i).status === "1" && dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name)
                    {
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

        }
        else
        {
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                {
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:dapModelPlugins.get(i).name,
                                               path: dapModelPlugins.get(i).path,
                                               verified:dapModelPlugins.get(i).verifed,
                                               show:true})
                }
            }
            if(modelMenuTab.count)
                pluginsTabChanged(true,false,"")
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
