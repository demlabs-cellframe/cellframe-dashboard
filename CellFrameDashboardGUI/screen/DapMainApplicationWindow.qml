import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3

import "qrc:/screen"
import "qrc:/widgets"
import "qrc:/screen/desktop/NetworksPanel"
import "qrc:/logic"

Rectangle {
    id: dapMainWindow

    ///@detalis Path to the dashboard tab.
    readonly property string dashboardScreenPath: path + "/Dashboard/DapDashboardTab.qml"
    ///@detalis Path to the exchange tab.
    readonly property string exchangeScreenPath: path + "/Exchange/DapExchangeTab.qml"
    ///@detalis Path to the history tab.
    readonly property string historyScreenPath: path + "/History/DapHistoryTab.qml"
    ///@detalis Path to the VPN service tab.
    readonly property string vpnServiceScreenPath: path + "/VPNService/DapVPNServiceTab.qml"
//    readonly property string vpnServiceScreenPath: path + "/VPNService_New/DapVPNServiceTab.qml"
    ///@detalis Path to the VPN client tab.
    readonly property string vpnClientScreenPath: path + "/VPNClient/DapVpnClientTab.qml"
    ///@detalis Path to the settings tab.
    readonly property string settingsScreenPath: path + "/Settings/DapSettingsTab.qml"
    ///@detalis Path to the logs tab.
    readonly property string logsScreenPath: path + "/Logs/DapLogsTab.qml"
    ///@detalis Path to the console tab.
    readonly property string consoleScreenPath: path + "/Console/DapConsoleTab.qml"
    ///@detalis Path to the certificates tab.
    readonly property string certificatesScreenPath: path + "/Certificates/DapCertificateTab.qml"
    ///@detalis Path to the tokens tab.
    readonly property string tokensScreenPath: path + "/Tokens/DapTokensTab.qml"
     ///@detalis Path to the plugins tab.
    readonly property string pluginsScreen: path + "/Plugins/Plugin/DapApp.qml"
    ///@detalis Path to the plugins tab.
    readonly property string miniGameScreen: path + "/Plugins/MiniGame/MiniGame.qml"
    ///@detalis Path to the dApps tab.
    readonly property string dAppsScreen: path + "/dApps/DapAppsTab.qml"

    readonly property string underConstructionsScreenPath: path + "/UnderConstructions.qml"

    MainApplicationLogic{id: logicMainApp}
    Settings {property alias menuTabStates: logicMainApp.menuTabStates}
    DapMessagePopup{id: messagePopup}

    signal menuTabChanged()
    onMenuTabChanged: logicMainApp.updateMenuTabStatus()
    signal pluginsTabChanged(var auto, var removed, var name)
    onPluginsTabChanged: logicMainApp.updateAppsTabStatus(auto, removed, name)

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()
    signal modelPluginsUpdated()

//    signal keyPressed(var event)
//    Keys.onPressed: keyPressed(event)

    //Models

    ListModel{id: dapNetworkModel}
    ListModel{id: dapModelWallets}
    ListModel{id: dapModelOrders}
    ListModel{id: dapModelPlugins}

    ListModel{
        id:themes
        Component.onCompleted:{
            append({name:qsTr("Dark theme"),
                    source:darkTheme})}
    }

    ListModel{id:modelAppsTabStates}

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

            logicMainApp.initTabs()
            pluginsTabChanged(true,false,"")
        }
    }

    //----------------------//


    anchors.centerIn: parent
    width: parent.width / scale
    height: parent.height / scale
    scale: 1.0
    color:currTheme.backgroundPanel

    // The horizontal location of the virtual menu column and tab view loader
    Row
    {
        id: rowMainWindow

        anchors {
            left: parent.left;
            top: parent.top;
            right: parent.right;
            bottom: networksPanel.top
            bottomMargin: 6 * pt
        }

        // Virtual logo column frame and menu bar
        Column
        {
            id: columnMenuTab
            z: 1
            height: rowMainWindow.height - 3 * pt
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

                    Image{
                        width: 114 * pt
                        height: 24 * pt
                        mipmap: true
                        source: "qrc:/resources/icons/" + pathTheme + "/cellframe-logo-dashboard.png"

                        anchors.left: parent.left
                        anchors.leftMargin: 23*pt
                        anchors.top: parent.top
                        anchors.topMargin: 19.86 * pt
                    }
                    ToolTip
                    {
                        id:toolTip
                        visible: area.containsMouse? true : false
                        text: "https://cellframe.net"
                        y:0
                        x:100
                        scale: mainWindow.scale
                        contentItem: Text {
                                text: toolTip.text
                                font: mainFont.dapFont.regular14
                                color: currTheme.textColor
                            }
                        background: Rectangle{color:currTheme.backgroundPanel}
                    }
                    MouseArea
                    {
                        id:area
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.openUrlExternally(toolTip.text)
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
                    widthIconItemMenu: 18 * pt
                    heightIconItemMenu: 18 * pt
                    dapMenuWidget.model: modelMenuTab
                    normalFont: "Quicksand"
                    selectedFont: "Quicksand"
                }
            }
        }

        DropShadow {
            z: 1
            anchors.fill: columnMenuTab
            horizontalOffset: currTheme.hOffset
            verticalOffset: currTheme.vOffset
            radius: currTheme.radiusShadow
            color: currTheme.shadowColor
            source: columnMenuTab
            spread: 0.1
            smooth: true
        }

        // Screen downloader widget
        Item
        {
            id: screens
//                data: dabScreensWidget
            x: columnMenuTab.width
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

    DapControlNetworksPanel
    {
        id: networksPanel
        height: 40 * pt
    }

    Rectangle {
        anchors.left: networksPanel.left
        anchors.right: networksPanel.right
        anchors.bottom: networksPanel.top
        height: 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: currTheme.backgroundPanel }
            GradientStop { position: 1.0; color: currTheme.reflectionLight }
        }
    }

    Component.onCompleted:
    {
//        dapServiceController.requestToService("DapGetListNetworksCommand", "chains")
        dapServiceController.requestToService("DapGetNetworksStateCommand")
//        dapServiceController.requestToService("DapGetListNetworksCommand")
        pluginsManager.getListPlugins();
//        dapServiceController.requestToService("DapGetWalletsInfoCommand")

        if (logicMainApp.menuTabStates)
            logicMainApp.loadSettingsTab()

    }

    Connections
    {
        target: dapServiceController

        onNetworksListReceived: logicMainApp.rcvNetList(networksList)
        onSignalStateSocket: logicMainApp.rcvStateNotify(isError, isFirst)

        onWalletsReceived:
        {
            print("onWalletsReceived")
            console.log("Wallets length:", walletList.length)
            logicMainApp.rcvWallets(walletList)
            modelWalletsUpdated();
        }

        onWalletReceived:
        {
            print("onWalletReceived")
            console.log("Wallet name:", wallet.Name)
            logicMainApp.rcvWallet(wallet)

            dapModelOrders.clear()
        }

        onOrdersReceived:
        {
            print("onOrdersReceived")
            console.log("Orders count:", orderList.length)
            logicMainApp.rcvOrders(orderList)
            modelOrdersUpdated();
        }
    }

    Connections{
        target: pluginsManager
        onRcvListPlugins:
        {
            print("onRcvListPlugins")
            console.log("Plugins count:", m_pluginsList.length)
            logicMainApp.rcvPlugins(m_pluginsList)

            modelPluginsUpdated()
            logicMainApp.updateModelAppsTab()
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
