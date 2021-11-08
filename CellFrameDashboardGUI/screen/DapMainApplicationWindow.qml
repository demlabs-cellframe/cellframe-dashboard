import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/screen"
import "qrc:/resources/QML"
import "qrc:/screen/desktop/Dashboard"
import "qrc:/screen/desktop/Exchange"
import "qrc:/screen/desktop/Certificates"
import "qrc:/screen/desktop/NetworksPanel"
import "qrc:/screen/desktop/RightPanel"
import "qrc:/screen/desktop/Settings"


Page {
    id: dapMainWindow
    ///@detalis Path to the tabs.
    readonly property string dashboardScreen: "qrc:/screen/" + device + "/Dashboard/DapDashboardTab.qml"
    readonly property string walletScreen: "qrc:/screen/" + device + "/Wallet/DapWalletTab.qml"
    readonly property string exchangeScreen: "qrc:/screen/" + device + "/Exchange/DapExchangeTab.qml"
    readonly property string historyScreen: "qrc:/screen/" + device + "/History/DapHistoryTab.qml"
    //    readonly property string vpnServiceScreen: "qrc:/screen/" + device + "/VPNService/DapVPNServiceTab.qml"
    readonly property string vpnServiceScreen: "qrc:/screen/" + device + "/VPNService_New/DapVPNServiceTab.qml"
    readonly property string vpnClientScreen: "qrc:/screen/" + device + "/VPNService/DapVPNServiceTab.qml"
    readonly property string settingsScreen: "qrc:/screen/" + device + "/Settings/DapSettingsTab.qml"
    readonly property string logsScreen: "qrc:/screen/" + device + "/Logs/DapLogsTab.qml"
    readonly property string consoleScreen: "qrc:/screen/" + device + "/Console/DapConsoleTab.qml"
    readonly property string certificatesScreen: "qrc:/screen/" + device + "/Certificates/DapCertificatesMainPage.qml"
    readonly property string underConstructionsScreen: "qrc:/screen/" + device + "/UnderConstructions.qml"

    readonly property string testScreen: "qrc:/screen/" + device + "/Test/TestPage.qml"

    ///@details dapMainFonts Project font loader
    readonly property QtObject dapMainFonts: DapFontRoboto {}
    //    readonly property QtObject dapQuicksandFonts: DapFontQuicksand {}
    property alias dapQuicksandFonts: quicksandFonts

//    property var dapWallets: []
//    property var dapOrders: []

    property var walletsNames: []
    property var networksNames: []
    property var tokensNames: []

    property var walletsModel: []
    property var networksModel: []
    property var tokensModel: []

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()


    background: Rectangle {
        color: currTheme.backgroundPanel
    }

    DapFontQuicksand {
        id: quicksandFonts
    }

    ///@detalis Logo icon.
    //        property alias dapIconLogotype: iconLogotype
    //        ///@detalis Logo frame.
    //        property alias dapFrameLogotype: frameLogotype
    //        ///@detalis Menu bar.
    //        property alias dapMenuTabWidget: menuTabWidget

    //        property alias dapScreenLoader: stackViewTabs

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
                width: menuTabWidget.width -8*pt
                height: 60 * pt
                Rectangle
                {
//                    data: dapLogotype
                    width: parent.width * pt
                    height: 60 * pt
                    //                        radius: 8 * pt
                    anchors.leftMargin: -8*pt
                    anchors.bottomMargin: -10*pt
                    Image
                    {
                        id: frameLogotype
                        anchors.fill: parent
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
            // Menu bar widget
            Item
            {
                id: menuWidget
                data: DapAbstractMenuTabWidget
                {
                    color: currTheme.backgroundPanel
                    radius: currTheme.radiusRectangle

                    anchors.leftMargin: -8*pt

                    onPathScreenChanged:
                    {
                        stackViewTabs.setSource(Qt.resolvedUrl(this.pathScreen))
                    }
                    anchors.fill: parent
                    dapFrameMenuTab.width: 180 * pt
                    widthItemMenu: 180*pt
                    heightItemMenu: 60 * pt
                    //                        normalColorItemMenu: "transparent"
                    normalColorItemMenu: currTheme.backgroundPanel
                    //                        selectColorItemMenu: "#D51F5D"
                    selectColorItemMenu: "transparent"
                    widthIconItemMenu: 18 * pt
                    heightIconItemMenu: 18 * pt
                    dapMenuWidget.model: modelMenuTab
                    normalFont: "Quicksand"
                    selectedFont: "Quicksand"
                }
                //hide top radius element
                Rectangle{
                    width: 5*pt
                    height: currTheme.radiusRectangle
                    anchors.top: parent.top
                    anchors.right: parent.right
                    color: currTheme.backgroundPanel
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
                source: dashboardScreen
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

    // Menu bar tab model
    ListModel
    {
        id: modelMenuTab


        
        Component.onCompleted:
        {
            /*append({
                name: qsTr("Wallet"),
                page: dashboardScreen,
                normalIcon: "qrc:/resources/icons/new-wallet_icon_dark.svg",
                hoverIcon: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
            })*/
            append({
                       name: qsTr("Wallet"),
                       page: dashboardScreen,
                       normalIcon: "qrc:/resources/icons/BlackTheme/icon_wallet.png",
                       hoverIcon: "qrc:/resources/icons/BlackTheme/icon_wallet.png"
                   })
            //TODO: The tab is disabled until the functional part is implemented
            append ({
                        name: qsTr("Exchange"),
                        page: underConstructionsScreen, //TODO: here should be: exchangeScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_exchange.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_exchange.png"
                    })

            append ({
                        name: qsTr("TX Explorer"),
                        page: historyScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_history.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_history.png"
                    })


            append ({
                        name: qsTr("Certificates"),
                        page: certificatesScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_certificates.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_certificates.png"
                    })

            append ({
                        name: qsTr("Tokens"),
                        page: underConstructionsScreen, //TODO: add screen for "Tokens" tab
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_tokens.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_tokens.png"
                    })


            append ({
                        name: qsTr("VPN client"),
                        page: underConstructionsScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/vpn-client_icon.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/vpn-client_icon.png"
                    })

            append ({
                        name: qsTr("VPN service"),
                        page: vpnServiceScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_vpn.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_vpn.png"
                    })


            append ({
                        name: qsTr("Console"),
                        page: consoleScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_console.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_console.png"
                    })

            append ({
                        name: qsTr("Settings"),
                        page: settingsScreen,
                        normalIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png",
                        hoverIcon: "qrc:/resources/icons/BlackTheme/icon_settings.png"
                    })
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
            }

            for(var n = 0; n < Object.keys(networkList).length; ++n)
            {
                dapNetworkModel.append({name: networkList[n]})
            }
        }

        onWalletsReceived:
        {
            for (var q = 0; q < walletList.length; ++q)
            {
                dapWallets.push(walletList[q])
            }

            for (var i = 0; i < dapWallets.length; ++i)
            {
                dapModelWallets.append({ "name" : dapWallets[i].Name,
                                           "balance" : dapWallets[i].Balance,
                                           "icon" : dapWallets[i].Icon,
                                           "address" : dapWallets[i].Address,
                                           "networks" : []})
                walletsNames.push(dapWallets[i].Name)
                walletsModel.push({ "name" : dapWallets[i].Name,
                                      "balance" : dapWallets[i].Balance,
                                      "icon" : dapWallets[i].Icon,
                                      "address" : dapWallets[i].Address,
                                      "networks" : networksModel})
                for (var n = 0; n < Object.keys(dapWallets[i].Networks).length; ++n)
                {
                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                                                               "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                                                               "tokens": []})

                    if (networksNames[n] !== dapWallets[i].Networks[n])
                        networksNames.push(dapWallets[i].Networks[n])

                    walletsModel[i].networks.push({"name": dapWallets[i].Networks[n],
                                                      "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                                                      "tokens": tokensModel})
                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                            dapModelWallets.get(i).networks.get(n).tokens.append(
                                        {"name": dapWallets[i].Tokens[t].Name,
                                            "balance": dapWallets[i].Tokens[t].Balance,
                                            "emission": dapWallets[i].Tokens[t].Emission,
                                            "network": dapWallets[i].Tokens[t].Network})
                            tokensNames.push(dapWallets[i].Tokens[t].Name)
                            tokensModel.push({
                                                 "name": dapWallets[i].Tokens[t].Name,
                                                 "balance": dapWallets[i].Tokens[t].Balance,
                                                 "emission": dapWallets[i].Tokens[t].Emission,
                                                 "network": dapWallets[i].Tokens[t].Network
                                             })
                        }
                    }
                }
            }

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
            }
            modelOrdersUpdated();
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
