import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import VPNOrdersController 1.0

import "qrc:/screen"
import "qrc:/widgets"
import "desktop/Networks"
import "qrc:/logic"
import "desktop/controls"

Rectangle {
    id: dapMainWindow

    ///@detalis Path to the dashboard tab.
    readonly property string dashboardScreenPath: path + "/Dashboard/DapDashboardTab.qml"
    ///@detalis Path to the stock tab.
    readonly property string stockScreenPath: path + "/Stock/DapStockTab.qml"
    ///@detalis Path to the history tab.
    readonly property string historyScreenPath: path + "/History/DapHistoryTab.qml"
    ///@detalis Path to the VPN service tab.
    readonly property string vpnServiceScreenPath: path + "/VPNService/DapVPNServiceTab.qml"
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


    readonly property string ordersScreen: path + "/Orders/DapOrdersTab.qml"

    readonly property string underConstructionsScreenPath: path + "/UnderConstructions.qml"
    
    property alias tryCreatePasswordWalletPopup: tryCreatePasswordWalletPopup
    property alias createPasswordWalletPopup: createPasswordWalletPopup
    property alias walletActivatePopup: walletActivatePopup
    property alias walletDeactivatePopup: walletDeactivatePopup
    property alias walletsControllerPopup: walletsControllerPopup
    property alias removeWalletPopup: removeWalletPopup
    property alias settingsWallet:settingsWallet

    property var vpnClientTokenModel: new Array()

    MainApplicationLogic{id: logicMainApp}
    Settings
    {
        id: settingsWallet
        property alias menuTabStates: logicMainApp.menuTabStates
        property string currentWalletName: logicMainApp.currentWalletName
        property string currentNetworkName: logicMainApp.currentNetworkName
        property int currentLanguageIndex: logicMainApp.currentLanguageIndex
        property string currentLanguageName: logicMainApp.currentLanguageName
        //property string currentWalletIndex: logicMainApp.currentWalletIndex

        Component.onCompleted:
        {
//            translator.setLanguage(
//                        modelLanguages.get(currentLanguageIndex).tag)

            console.log("Settings", "currentWalletName", currentWalletName)
            console.log("Settings", "currentNetworkName", currentNetworkName)
            console.log("Settings", "currentLanguageIndex", currentLanguageIndex)
            console.log("Settings", "currentLanguageName", currentLanguageName)

            logicMainApp.currentWalletName = currentWalletName
            logicMainApp.currentNetworkName = currentNetworkName
            logicMainApp.currentLanguageIndex = currentLanguageIndex
//            logicMainApp.currentWalletIndex = currentWalletIndex

        }
    }
    Timer {id: timer}

    ListModel {id: networksModel}
    ListModel {id: diagnosticDataModel}

//    CopyPopup{id: copyPopup}
    DapMessagePopup{ id: messagePopup}
//    DapMessagePopup{
//        property int index
//        id: messageWebConnect
//        onSignalAccept: webControl.rcvAccept(accept, index)
//    }
    DapVersionPopup
    {
        id: messagePopupVersion

        signal click()
        onSignalAccept:
        {
            if(dapButtonOk.textButton === "Update" && accept)
                logicMainApp.updateDashboard()
            click()
        }
    }

    DapWebMessagePopup{
        id: webPopup
    }

    DapPopupInfo
    {
        id: popupInfo
    }

    DapTryCreatePasswordWalletPopup{
        id: tryCreatePasswordWalletPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapCreatePasswordWalletPopup{
        id: createPasswordWalletPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapActivateWalletPopup{
        id: walletActivatePopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapDeactivateWalletPopup{
        id: walletDeactivatePopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapWalletsControllerPopup{
        id: walletsControllerPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapRemoveWalletPopup{
        id: removeWalletPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    property alias infoItem: popupInfo

    signal menuTabChanged()
    onMenuTabChanged: logicMainApp.updateMenuTabStatus()
    signal pluginsTabChanged(var auto, var removed, var name)
    onPluginsTabChanged: logicMainApp.updateAppsTabStatus(auto, removed, name)

    signal changeHeight()
    onHeightChanged: changeHeight()

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()
    signal modelPluginsUpdated()
    signal modelTokensUpdated()
    signal modelXchangeOrdersUpdated()
    signal modelPairsUpdated()
    signal modelTokenPriceHistoryUpdated()
    signal checkWebRequest()
    signal openRequests()

    VPNOrdersController
    {
        id: vpnOrdersController
    }



//    signal keyPressed(var event)
//    Keys.onPressed: keyPressed(event)



    Settings {
        id: banSettings
        property string webSites: logicMainApp.serializeWebSite()

        Component.onCompleted: {
            if(webSites !== "") {
                dapWebSites.clear();
                var lines = webSites.split(";");
                for(var i = 0; i < lines.length; i++) {
                    var parts = lines[i].split(",");
                    dapWebSites.append({site: parts[0], enabled: JSON.parse(parts[1])});
                }
            }
        }
    }


    //Models

    ListModel{id: dapNetworkModel}
    ListModel{id: dapModelOrders}
    ListModel{id: dapModelPlugins}
    ListModel{id: dapModelTokens}
    ListModel{id: dapMessageBuffer}
    ListModel{id: dapMessageLogBuffer}
    ListModel{id: dapModelXchangeOrders}
    ListModel{
        id: dapWebSites

        onCountChanged: {
            banSettings.webSites = logicMainApp.serializeWebSite()
        }
    }

    ListModel{id: fakeWallet}

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
//        ListElement { tag: "VPN service"
//            name: qsTr("VPN service")
//            show: true }
        ListElement { tag: "Console"
            name: qsTr("Console")
            show: true }
        ListElement { tag: "Logs"
            name: qsTr("Logs")
            show: true }
        ListElement { tag: "dApps"
            name: qsTr("dApps")
            show: true }
        ListElement { tag: "Diagnostics"
            name: qsTr("Diagnostics")
            show: true }
        ListElement { tag: "Orders"
            name: qsTr("Orders")
            show: true }
    }

    ListModel
    {
        id: modelMenuTab

        Component.onCompleted:
        {
        append ({ tag: "Wallet",
            name: qsTr("Wallet"),
            bttnIco: "icon_wallet.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Dashboard/DapDashboardTab.qml"})
//        append ({ tag: "DEX",
//            name: qsTr("DEX Alpha"),
//            bttnIco: "icon_exchange.svg",
//            showTab: true,
//            page: "qrc:/screen/desktop/Stock/DapStockTab.qml"})
        append ({ tag: "DEX",
            name: qsTr("DEX"),
            bttnIco: "icon_exchange.svg",
            showTab: true,
            page: "qrc:/screen/desktop/UnderConstructions.qml"})


        append ({ tag: "TX explorer",
            name: qsTr("TX explorer"),
            bttnIco: "icon_history.svg",
            showTab: true,
            page: "qrc:/screen/desktop/History/DapHistoryTab.qml"})
        append ({ tag: "Certificates",
            name: qsTr("Certificates"),
            bttnIco: "icon_certificates.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Certificates/DapCertificateTab.qml"})
        append ({ tag: "Tokens",
            name: qsTr("Tokens"),
            bttnIco: "icon_tokens.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Tokens/TokensTab.qml"})
        append ({ tag: "Orders",
            name: qsTr("Orders"),
            bttnIco: "icon_vpn_service.svg",
            showTab: true,
            page: "qrc:/screen/desktop//Orders/DapOrdersTab.qml"})
//        append ({ tag: "VPN client",
//            name: qsTr("VPN client"),
//            bttnIco: "icon_vpn_client.svg",
//            showTab: true,
//            page: "qrc:/screen/desktop/UnderConstructions.qml"})
//        append ({ tag: "VPN service",
//            name: qsTr("VPN service"),
//            bttnIco: "icon_vpn_service.svg",
//            showTab: true,
//            page: "qrc:/screen/desktop/VPNService/DapVPNServiceTab.qml"})
        append ({ tag: "Console",
            name: qsTr("Console"),
            bttnIco: "icon_console.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Console/DapConsoleTab.qml"})
        append ({ tag: "Logs",
            name: qsTr("Logs"),
            bttnIco: "icon_logs.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Logs/DapLogsTab.qml"})

            /// NEW MASTER NODE TAB
//        append ({ tag: "Master Node",
//                name: qsTr("Master Node"),
//                bttnIco: "icon_master_node.svg",
//                showTab: true,
//                page: "qrc:/screen/desktop/MasterNode/DapMasterNodeTab.qml"})

        append ({ tag: "Settings",
            name: qsTr("Settings"),
            bttnIco: "icon_settings.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Settings/DapSettingsTab.qml"})
        append ({ tag: "dApps",
            name: qsTr("dApps"),
            bttnIco: "icon_daaps.svg",
            showTab: true,
            page: "qrc:/screen/desktop/dApps/DapAppsTab.qml"})
        append ({ tag: "Diagnostics",
            name: qsTr("Diagnostics"),
            bttnIco: "icon_settings.svg",
            showTab: true,
            page: "qrc:/screen/desktop/Diagnostic/DapDiagnosticTab.qml"})

//            FOR DEBUG
//        append ({ tag: "Plugin",
//            name: qsTr("Plugin"),
//            bttnIco: "icon_settings.svg",
//            showTab: true,
//            page: "qrc:/screen/desktop/Plugins/Plugin/DapApp.qml"})

            logicMainApp.initTabs()
            pluginsTabChanged(true,false,"")
        }
    }

    ListModel
    {
        id: modelLanguages
        ListElement { tag: "en"
            name: "English"}
        ListElement { tag: "zh"
            name: "Chinese"}
        ListElement { tag: "cs"
            name: "Czech"}
        ListElement { tag: "nl"
            name: "Dutch"}
        ListElement { tag: "pt"
            name: "Portuguese"}
        ListElement { tag: "ru"
            name: "Russian"}
    }


    //----------------------//

    anchors.centerIn: parent
    width: parent.width / scale
    height: parent.height / scale
    scale: 1.0
    color:currTheme.mainBackground

    Item {
        // Global parameter for expand or compact mode of LeftMenuButtons
        // Set true for enable moving animation
        property bool canCompactLeftMenu: false
        // Current state of LeftMenuButtons
        property bool isCompact: canCompactLeftMenu

        property int compactWidth: 76
        property int expandWidth: 180

        id: mainRowLayout
        anchors {
            left: parent.left;
            top: parent.top;
            right: parent.right;
            bottom: networksPanel.top
        }

        Rectangle {
            id: leftMenuBackGrnd
            width: mainRowLayout.isCompact ? mainRowLayout.compactWidth : mainRowLayout.expandWidth
            height: parent.height - 7
            radius: 20
            color: currTheme.mainBackground
            anchors.left: parent.left
            anchors.bottomMargin: 7

            Behavior on width { NumberAnimation { duration: 150 } }

            //hide bottom radius element
            Rectangle
            {
                z:0
                width: leftMenuBackGrnd.radius
                color: currTheme.mainBackground
                anchors.bottom: leftMenuBackGrnd.bottom
                anchors.left: leftMenuBackGrnd.left
                anchors.top: leftMenuBackGrnd.top
            }
            //hide top radius element
            Rectangle {
                z:0
                height: currTheme.frameRadius + 10
                width: leftMenuBackGrnd.radius
                anchors.top:leftMenuBackGrnd.top
                anchors.right: leftMenuBackGrnd.right
                color: currTheme.mainBackground
            }

            ColumnLayout {
                id: mainButtonsColumn
                anchors.fill: parent
                spacing: 0

                Item {
                    id: logo
                    Layout.fillWidth: true
                    height: 60
                    clip: true

                    Image {
                        width: 24
                        height: 22
                        mipmap: true
                        source: "qrc:/Resources/" + pathTheme + "/only-logo-dashboard.svg"
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 24
                        anchors.topMargin: 20
                    }

                    Image {
                        height: 22
                        mipmap: true
                        source: "/Resources/BlackTheme/cellframe-logo-dashboard.svg"
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.leftMargin: 24
                        anchors.topMargin: 20
                        opacity: mainRowLayout.isCompact ? 0.0 : 1.0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }

                    DapCustomToolTip{
                        id: toolTip
                        visible: area.containsMouse? true : false
                        contentText: "https://cellframe.net"
                        textFont: mainFont.dapFont.regular14
                        onVisibleChanged: updatePos()
                        y: 45
                    }

                    MouseArea
                    {
                        id:area
                        width: parent.width
                        height: parent.height
                        hoverEnabled: true
                        propagateComposedEvents: true

                        onClicked: Qt.openUrlExternally(toolTip.contentText)
                        onEntered: canCompactLeftMenu ? mainRowLayout.expandOrCompress(true) : {}
                        onExited: canCompactLeftMenu ? mainRowLayout.expandOrCompress(false) : {}
                    }
                }

                ListView {
                    id: mainButtonsList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 0
                    clip: true
                    model: modelMenuTab

                    delegate: DapMenuButton {
                        id: menuButton
                        pathScreen: page
                        onPushPage: {
                            if(pageUrl !== mainScreenStack.currPage)
                                mainScreenStack.setInitialItem(pageUrl)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: mainScreen
            //width: parent.width - leftMenuBackGrnd.width
            width: mainRowLayout.isCompact ? dapMainWindow.width - mainRowLayout.compactWidth : dapMainWindow.width - mainRowLayout.expandWidth
            height: parent.height
            color: currTheme.mainBackground
            anchors.right: parent.right

            StackView {
                property string currPage: dashboardScreenPath
                id: mainScreenStack
                anchors.fill: parent

                initialItem: dashboardScreenPath

                function clearAll()
                {
                    mainScreenStack.clear()
                    mainScreenStack.push(initialItem)
                }

                function setInitialItem(item)
                {
                    mainScreenStack.initialItem = item
                    mainScreenStack.clearAll()
                    currPage = item
                }
            }
        }

        Timer {
            id: expandTimer
            interval: 100
            repeat: false
            running: false
        }

        function expandOrCompress(expand) {
            expandTimer.stop()
            expandTimer.triggered.connect(function() {
                mainRowLayout.isCompact = !expand
            })
            expandTimer.start()
        }
    }

    DropShadow {
        anchors.fill: parent
        horizontalOffset: currTheme.hOffset
        verticalOffset: currTheme.vOffset
        radius: currTheme.radiusShadow
        color: currTheme.shadowColor
        source: leftMenuBackGrnd
        spread: 0.1
        smooth: true
    }

    DapNetworksPanel
    {
        id: networksPanel
        height: 40
    }

    Rectangle {
        anchors.left: networksPanel.left
        anchors.right: networksPanel.right
        anchors.bottom: networksPanel.top
        height: 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: currTheme.mainBackground }
            GradientStop { position: 1.0; color: currTheme.reflectionLight }
        }
    }

    Component.onCompleted:
    {
//        console.log("Component.onCompleted", "modelLanguages", modelLanguages)

//        translator.setLanguage("ru")
//        dapServiceController.requestToService("DapGetNetworksStateCommand")
//        logicMainApp.requestToService("DapVersionController", "version")

//        var timeTo = 10
//        var timeFrom = 20
//        var addr = "abcd"
//        var net = "private"

//        candleChartWorker.resetPriceData(0.0,"0.0", true)
//        orderBookWorker.resetBookModel()
//        //-------//OrdersHistory
//        dapServiceController.requestToService("DapGetXchangeTxList", "GetOrdersPrivate", net, addr, timeFrom, timeTo)
//        dapServiceController.requestToService("DapGetXchangeTxList", "GetOrdersPrivate", net, addr, "", "")

//        dapServiceController.requestToService("DapGetXchangeTxList", "", net, "", timeFrom, timeTo)
//        dapServiceController.requestToService("DapGetXchangeTxList", "", net, "", "", "")
//        //-------//CreateOrder
//        var tokenSell = "sell"
//        var tokenBuy = "buy"
//        var wallet = "tokenWallet"
//        var coins = 100000
//        var rate = 1
//        dapServiceController.requestToService("DapXchangeOrderCreate", net, tokenSell, tokenBuy, wallet, coins, rate)
        //------//GetOrdersList
//        dapServiceController.requestToService("DapGetXchangeOrdersList")

        //-------//TokenPair
//        dapServiceController.requestToService("DapGetXchangeTokenPair", "subzero", "full_info")
//        dapServiceController.requestToService("DapGetXchangeTokenPriceAverage", "subzero", "NCELL", "MILT")



        dAppsModule.getListPlugins();

        if (logicMainApp.menuTabStates)
            logicMainApp.loadSettingsTab()

//        for(var i = 0; i < 50; i++)
//            dapServiceController.requestToService("DapWebConnectRequest", "1")



    }

    Connections
    {
        target: settingsModule

        function onSigVersionInfo(versionResult)
        {
            if(versionResult.hasUpdate && versionResult.message === "Reply version")
                logicMainApp.rcvNewVersion(settingsModule.dashboardVersion, versionResult)
            else
                console.log(versionResult.message)
        }
    }

    Connections
    {
        target: dapServiceController

        function onNetworksListReceived(networksList) { logicMainApp.rcvNetList(networksList)}
        function onSignalStateSocket(state, isError, isFirst) {logicMainApp.rcvStateNotify(isError, isFirst)}
        function onCliConnectChanged(is_connected) { if(is_connected) console.log("Cli connected to node"); else console.log("Cli disconnected from node") }

//        function onVersionControllerResult(versionResult)
//        {
//            if(versionResult.hasUpdate && versionResult.message === "Reply version")
//                logicMainApp.rcvNewVersion(dapServiceController.Version, versionResult)
//            else if(versionResult.message === "Reply node version")
//            {
//                if(logicMainApp.nodeVersion === "" || logicMainApp.nodeVersion !== versionResult.lastVersion)
//                logicMainApp.nodeVersion = versionResult.lastVersion
//            }
//            else
//                console.log(versionResult.message)
////            else if(!versionResult.hasUpdate && versionResult.message === "Reply version")
////                logicMainApp.rcvReplyVersion()
////            else if(versionResult.message !== "Reply version")
////                logicMainApp.updatingDashboard()



////            console.log(dapServiceController.Version, versionResult.lastVersion, versionResult.hasUpdate, versionResult.message)
//        }

//        function onWalletsReceived(walletList)
//        {
//            console.log("onWalletsReceived")
//            logicMainApp.rcvWallets(walletList)
//        }
//        function onWalletReceived(wallet)
//        {
//            console.log("onWalletReceived")
//            logicMainApp.rcvWallet(wallet)
//        }


//        function onOrdersReceived(orderList)
//        {
//            console.log("onOrdersReceived")
//            console.log("Orders count:", orderList.length)
//            logicMainApp.rcvOrders(orderList)
//            modelOrdersUpdated();
//        }

        function onSignalTokensListReceived(tokensResult)
        {
            console.log("TokensListReceived")
            logicMainApp.rcvTokens(tokensResult)
        }

        function onDapWebConnectRequest(rcvData) { logicMainApp.rcvWebConnectRequest(rcvData)}

        function onSignalXchangeOrderListReceived(rcvData)
        {
            console.log("onSignalXchangeOrderListReceived")
            logicMainApp.rcvOpenOrders(rcvData)
        }

        function onSignalXchangeTokenPairReceived()
        {
            console.log("onSignalXchangeTokenPairReceived")
//            logicMainApp.rcvPairsModel(rcvData)
        }
    }
    Connections{
        target: dAppsModule
        function onRcvListPlugins(m_pluginsList)
        {
            console.log("onRcvListPlugins")
            console.log("Plugins count:", m_pluginsList.length)
            logicMainApp.rcvPlugins(m_pluginsList)

            modelPluginsUpdated()
            logicMainApp.updateModelAppsTab()
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
 ##^##*/
