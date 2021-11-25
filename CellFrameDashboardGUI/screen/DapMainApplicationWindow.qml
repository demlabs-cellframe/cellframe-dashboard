import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/screen"
import "qrc:/resources/QML"
import "qrc:/screen/desktop/Dashboard"
import "qrc:/screen/desktop/Exchange"
import "qrc:/screen/desktop/Certificates"
import "qrc:/screen/desktop/NetworksPanel"
import "qrc:/screen/desktop/RightPanel"
import "qrc:/screen/desktop/Settings"
import "desktop/SettingsWallet.js" as SettingsWallet


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
    ///@detalis Path to the console tab.
    readonly property string certificatesScreenPath: "qrc:/screen/" + device + "/Certificates/DapCertificatesMainPage.qml"
    ///@detalis Path to the console tab.
    readonly property string tokensScreenPath: "qrc:/screen/" + device + "/Tokens/DapTokensTab.qml"
     ///@detalis Path to the console tab.
    readonly property string pluginsScreen: "qrc:/screen/" + device + "/Plugins/DapPluginsTab.qml"


    readonly property string underConstructionsScreenPath: "qrc:/screen/" + device + "/UnderConstructions.qml"

    readonly property string testScreenPath: "qrc:/screen/" + device + "/Test/TestPage.qml"

    ///@details dapMainFonts Project font loader
    readonly property QtObject dapMainFonts: DapFontRoboto {}
//    readonly property QtObject dapQuicksandFonts: DapFontQuicksand {}
    property alias dapQuicksandFonts: quicksandFonts
    DapFontQuicksand {
        id: quicksandFonts
    }

    property string currentTab: stackViewTabs.source

    ListModel
    {
        id: operationModel
        ListElement { name: qsTr("Create wallet")
            operation: "create" }
        ListElement { name: qsTr("Restore wallet")
            operation: "restore" }
    }

    property var walletOperation: operationModel.get(0).operation
    property string walletRecoveryType: "Nothing"

        ///@detalis Logo icon.
//        property alias dapIconLogotype: iconLogotype
//        ///@detalis Logo frame.
//        property alias dapFrameLogotype: frameLogotype
//        ///@detalis Menu bar.
//        property alias dapMenuTabWidget: menuTabWidget

//        property alias dapScreenLoader: stackViewTabs



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
            bottom: networksPanel.top
            bottomMargin: 4 * pt
        }

        // Virtual logo column frame and menu bar
        Column
        {
            id: columnMenuTab
            height: rowMainWindow.height
            width: 180 * pt
            // Logotype widget
            Item
            {
                id: logotype
//                    data: dapLogotype
                width: parent.width * pt
                height: 60 * pt
                Rectangle
                {
                    id: frameLogotype
                    anchors.fill: parent
                    color:currTheme.backgroundPanel
//                        width: parent.width
//                        radius: 8 * pt
                    Image
                    {
                        id: iconLogotype
//                            anchors.verticalCenter: parent.verticalCenter
                        width: 111 * pt
                        height: 24 * pt
                        anchors.left: parent.left
                        anchors.leftMargin: 26*pt
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 18*pt
                        anchors.top: parent.top
                        anchors.topMargin: 18 * pt

                        source: "qrc:/resources/icons/BlackTheme/cellframe-logo-dashboard.png"
                    }
                }
            }
            // Menu bar widget
            Item
            {
                id: menuWidget
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
                    widthItemMenu: 180*pt
                    heightItemMenu: 52 * pt
                    normalColorItemMenu: currTheme.backgroundPanel
                    selectColorItemMenu: "transparent"
                    widthIconItemMenu: 16 * pt
                    heightIconItemMenu: 16 * pt
                    dapMenuWidget.model: modelMenuTab
                    normalFont: "Quicksand"
                    selectedFont: "Quicksand"
                }
                //hide top radius element
                Rectangle{
                    width: 9 * pt
                    height: currTheme.radiusRectangle
                    anchors.top:parent.top
                    anchors.right: parent.right
                    color: currTheme.backgroundPanel/* "white"*/
//                        radius: currTheme.radiusRectangle
                    Rectangle
                    {
                        width: 9 * pt
                        height: 4 * pt
                        anchors.top: parent.top
                        anchors.right: parent.left
                        color: parent.color
                    }
                }

                width: 180 * pt
                height: columnMenuTab.height - logotype.height
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

    DapNetworksPanel
    {
        id: networksPanel
        y: parent.height - height
        width: parent.width
    }

    DapNetworkPopup
    {
        id: networkPanelPopup
    }


    property var dapWallets: []
    property var dapOrders: []
    property var dapPlugins: []

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()
    signal modelPluginsUpdated()


    //open in module visible root context, only for work
    Component{
        DapCertificatesMainPage { }
    }

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

    // Menu bar tab model
    ListModel 
    {
        id: modelMenuTab


        
        Component.onCompleted:
        {
            /*append({
                name: qsTr("Wallet"),
                page: dashboardScreenPath,
                normalIcon: "qrc:/resources/icons/new-wallet_icon_dark.svg",
                hoverIcon: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
            })*/
            append({
                name: qsTr("Wallet"),
                page: dashboardScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_wallet.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_wallet.png"
            })
//TODO: The tab is disabled until the functional part is implemented
            append ({
                name: qsTr("Exchange"),
                page: underConstructionsScreenPath, //TODO: here should be: exchangeScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_exchange.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_exchange.png"
            })
    
            append ({
                name: qsTr("TX Explorer"),
                page: historyScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_history.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_history.png"
            })


            append ({
                name: qsTr("Certificates"),
                page: certificatesScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_certificates.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_certificates.png"
            })

            append ({
                name: qsTr("Tokens"),
                page: underConstructionsScreenPath, //TODO: add screen for "Tokens" tab
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_tokens.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_tokens.png"
            })


            append ({
                name: qsTr("VPN client"),
                page: underConstructionsScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/vpn-client_icon.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/vpn-client_icon.png"
            })

            append ({
                name: qsTr("VPN service"),
                page: vpnServiceScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_vpn.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_vpn.png"
            })


            append ({
                name: qsTr("Console"),
                page: consoleScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_console.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_console.png"
            })

            append ({
                name: qsTr("Settings"),
                page: settingsScreenPath,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png"
            })
            append ({
                name: qsTr("Plugins"),
                page: pluginsScreen,
                normalIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png"
            })

            //Test elements page for debug
//            append ({
//                name: qsTr("Test"),
//                page: testScreen,
//                normalIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
//                hoverIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png"
//            })
//            append ({
//                name: qsTr("Logs"),
//                page: logsScreenPath,
//                normalIcon: "qrc:/resources/icons/icon_logs.svg",
//                hoverIcon: "qrc:/resources/icons/icon_logs_hover.svg"
//             })
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
    //NetworkPanel shadow
    DropShadow {
            anchors.fill: networksPanel
            radius: currTheme.radiusShadowSmall
            color: currTheme.reflectionLight
            source: networksPanel
            spread: 0.7
        }


    Component.onCompleted:
    {
        dapServiceController.requestToService("DapGetListNetworksCommand")
        pluginsManager.getListPlugins();
//        dapServiceController.requestToService("DapGetWalletsInfoCommand")
    }

    Connections
    {
        target: dapServiceController

        onNetworksListReceived:
        {
            console.log("Networks list received")

            if (!networkList)
                console.error("networkList is empty")
            else
            {
                dapServiceController.CurrentNetwork = networkList[0];
                dapServiceController.IndexCurrentNetwork = 0;

                console.log("Current network: "+dapServiceController.CurrentNetwork)
            }

            for(var n=0; n < Object.keys(networkList).length; ++n)
            {
                dapNetworkModel.append({name: networkList[n]})
            }
        }

        onWalletsReceived:
        {
            dapWallets.splice(0,dapPlugins.length)
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
                                      "balance" : dapWallets[i].Balance,
                                      "icon" : dapWallets[i].Icon,
                                      "address" : dapWallets[i].Address,
                                      "networks" : []})
                console.log("Networks number: "+Object.keys(dapWallets[i].Networks).length)
                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
                {
                    console.log("Network name: "+dapWallets[i].Networks[n])
                    print("address", dapWallets[i].findAddress(dapWallets[i].Networks[n]))
                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                          "tokens": []})
                    console.log("Tokens.length:", Object.keys(dapWallets[i].Tokens).length)
                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                            console.log(dapWallets[i].Tokens[t].Network + " === " + dapWallets[i].Networks[n])
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": dapWallets[i].Tokens[t].Name,
                                  "balance": dapWallets[i].Tokens[t].Balance,
                                  "emission": dapWallets[i].Tokens[t].Emission,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }
                }
            }

            if (dapModelWallets.count > 0)
                SettingsWallet.currentIndex = 0
            else
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
                                        "status" : dapPlugins[q][2]})
            }
            modelPluginsUpdated()
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
