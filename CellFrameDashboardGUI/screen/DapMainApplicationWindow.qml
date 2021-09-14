import QtQuick 2.4
import "qrc:/screen"
import "qrc:/resources/QML"
import "qrc:/screen/desktop/Dashboard"
import "qrc:/screen/desktop/Exchange"
import "qrc:/screen/desktop/Certificates"
import "qrc:/screen/desktop/NetworksPanel"
import "qrc:/screen/desktop/RightPanel"
import "qrc:/screen/desktop/Settings"



Item {
    id: dapMainWindow
    ///@detalis Path to the dashboard tab.
    readonly property string dashboardScreen: "qrc:/screen/" + device + "/Dashboard/DapDashboardTab.qml"
    ///@detalis Path to the dashboard tab.
    readonly property string walletScreen: "qrc:/screen/" + device + "/Wallet/DapWalletTab.qml"
    ///@detalis Path to the exchange tab.
    readonly property string exchangeScreen: "qrc:/screen/" + device + "/Exchange/DapExchangeTab.qml"
    ///@detalis Path to the history tab.
    readonly property string historyScreen: "qrc:/screen/" + device + "/History/DapHistoryTab.qml"
    ///@detalis Path to the VPN service tab.
    readonly property string vpnServiceScreen: "qrc:/screen/" + device + "/VPNService/DapVPNServiceTab.qml"
    ///@detalis Path to the settings tab.
    readonly property string settingsScreen: "qrc:/screen/" + device + "/Settings/DapSettingsTab.qml"
    ///@detalis Path to the logs tab.
    readonly property string logsScreen: "qrc:/screen/" + device + "/Logs/DapLogsTab.qml"
    ///@detalis Path to the console tab.
    readonly property string consoleScreen: "qrc:/screen/" + device + "/Console/DapConsoleTab.qml"

    ///@detalis Path to the console tab.
    readonly property string certificatesScreen: "qrc:/screen/" + device + "/Certificates/DapCertificatesMainPage.qml"

    ///@details dapMainFonts Project font loader
    readonly property QtObject dapMainFonts: DapFontRoboto {}
//    readonly property QtObject dapQuicksandFonts: DapFontQuicksand {}
    property alias dapQuicksandFonts: quicksandFonts
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
                    data: dapLogotype
                    width: columnMenuTab.width
                    height: 60 * pt
                    Rectangle
                    {
                        id: frameLogotype
                        anchors.fill: parent
                        color: "#070023"
                        height: 60 * pt
//                        radius: 8 * pt
                        anchors.leftMargin: -8*pt
                        anchors.bottomMargin: -10*pt
                        Image
                        {
                            id: iconLogotype
                            anchors.verticalCenter: parent.verticalCenter
                            width: 111 * pt
                            height: 24 * pt
                            anchors.left: parent.left
                            anchors.leftMargin: 24 * pt
                            source: "qrc:/resources/icons/Certificates/cellframe-logo-dashboard.svg"
                        }
                    }
                }
                // Menu bar widget
                Item
                {
                    id: menuWidget
                    data: DapAbstractMenuTabWidget
                    {
//                        radius: 8 * pt
                        anchors.leftMargin: -8*pt

                        onPathScreenChanged:
                        {
                            stackViewTabs.setSource(Qt.resolvedUrl(this.pathScreen))
                        }
                        id: menuTabWidget
                        anchors.fill: parent
                        dapFrameMenuTab.width: 180 * pt
                        heightItemMenu: 60 * pt
                        normalColorItemMenu: "transparent"
                        selectColorItemMenu: "#D51F5D"
                        widthIconItemMenu: 18 * pt
                        heightIconItemMenu: 18 * pt
                        dapMenuWidget.model: modelMenuTab
                        normalFont: "Quicksand"
                        selectedFont: "Quicksand"
                    }

                    width: 200*pt
                    height: columnMenuTab.height - logotype.height
                }
            }

            // Screen downloader widget
            Item
            {
                id: screens
                data: dabScreensWidget
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



    property var dapWallets: []

    signal modelWalletsUpdated()


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
                normalIcon: "qrc:/resources/icons/icon_dashboard.png",
                hoverIcon: "qrc:/resources/icons/icon_dashboard_hover.png"
            })
//TODO: The tab is disabled until the functional part is implemented
//            append ({
//                name: qsTr("Exchange"),
//                page: historyScreen, //TODO: here should be: exchangeScreen,
//                normalIcon: "qrrc:/resources/icons/icon_exchange.png",
//                hoverIcon: "qrc:/resources/icons/icon_exchange_hover.png"
//            })
    
            append ({
                name: qsTr("History"),
                page: historyScreen,
                normalIcon: "qrc:/resources/icons/icon_history.svg",
                hoverIcon: "qrc:/resources/icons/icon_history_hover.svg"
            })


            append ({
                name: qsTr("Certificates"),
                page: certificatesScreen,
                normalIcon: "qrc:/resources/icons/Certificates/icon_certificates.svg",
                hoverIcon: "qrc:/resources/icons/Certificates/icon_certificates_hover.svg"
            })

            append ({
                name: qsTr("Tokens"),
                page: historyScreen, //TODO: add screen for "Tokens" tab
                normalIcon: "qrc:/resources/icons/ic_tokens.svg",
                hoverIcon: "qrc:/resources/icons/ic_tokens_hover.svg"
            })


            append ({
                name: qsTr("VPN client"),
                page: settingsScreen,
                normalIcon: "qrc:/resources/icons/ic_vpn-client.svg",
                hoverIcon: "qrc:/resources/icons/ic_vpn-client_hover.svg"
            })

            append ({
                name: qsTr("VPN service"),
                page: vpnServiceScreen,
                normalIcon: "qrc:/resources/icons/icon_vpn-service.svg",
                hoverIcon: "qrc:/resources/icons/icon_vpn-service_hover.svg"
            })


            append ({
                name: qsTr("Console"),
                page: consoleScreen,
                normalIcon: "qrc:/resources/icons/icon_console.png",
                hoverIcon: "qrc:/resources/icons/icon_console_hover.png"
            })

            append ({
                name: qsTr("Settings"),
                page: settingsScreen,
                normalIcon: "qrc:/resources/icons/icon_settings.png",
                hoverIcon: "qrc:/resources/icons/icon_settings_hover.png"
            })

//            append ({
//                name: qsTr("Logs"),
//                page: logsScreen,
//                normalIcon: "qrc:/resources/icons/icon_logs.svg",
//                hoverIcon: "qrc:/resources/icons/icon_logs_hover.svg"
//             })
        }
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

                console.log("Current network: "+dapServiceController.CurrentNetwork)
            }

            for(var n=0; n < Object.keys(networkList).length; ++n)
            {
                dapNetworkModel.append({name: networkList[n]})
            }
        }

        onWalletsReceived:
        {
            console.log(walletList.length)
            console.log(dapWallets.length)
            console.log(dapModelWallets.count)
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
                    print(dapModelWallets.get(i).networks)
                    print("name", dapWallets[i].Networks[n])
                    print("address", dapWallets[i].findAddress(dapWallets[i].Networks[n]))
                    dapModelWallets.get(i).networks.append({"name": dapWallets[i].Networks[n],
                          "address": dapWallets[i].findAddress(dapWallets[i].Networks[n]),
                          "tokens": []})
                    console.log(Object.keys(dapWallets[i].Tokens).length)
                    for (var t = 0; t < Object.keys(dapWallets[i].Tokens).length; ++t)
                    {
                        console.log(dapWallets[i].Tokens[t].Network + " === " + dapWallets[i].Networks[n])
                        if(dapWallets[i].Tokens[t].Network === dapWallets[i].Networks[n])
                        {
                             dapModelWallets.get(i).networks.get(n).tokens.append(
                                 {"name": dapWallets[i].Tokens[t].Name,
                                  "balance": dapWallets[i].Tokens[t].Balance,
                                  "emission": dapWallets[i].Tokens[t].Emission,
                                  "network": dapWallets[i].Tokens[t].Network})
                        }
                    }

                }

            }
            modelWalletsUpdated();
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
