import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
// import VPNOrdersController 1.0

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
    property alias removeOrderPopup: removeOrderPopup
    property alias settingsWallet:settingsWallet

    property var vpnClientTokenModel: new Array()

    signal showPopupUpdateNode();

    MainApplicationLogic{id: logicMainApp}
    Settings
    {
        id: settingsWallet
        property alias menuTabStates: logicMainApp.menuTabStates
        property string currentWalletName: logicMainApp.currentWalletName
        property int currentLanguageIndex: logicMainApp.currentLanguageIndex
        property string currentLanguageName: logicMainApp.currentLanguageName
        //property string currentWalletIndex: logicMainApp.currentWalletIndex

        Component.onCompleted:
        {
//            translator.setLanguage(
//                        modelLanguages.get(currentLanguageIndex).tag)

            console.log("Settings", "currentWalletName", currentWalletName)
            console.log("Settings", "currentLanguageIndex", currentLanguageIndex)
            console.log("Settings", "currentLanguageName", currentLanguageName)

            logicMainApp.currentWalletName = currentWalletName
            logicMainApp.currentLanguageIndex = currentLanguageIndex
//            logicMainApp.currentWalletIndex = currentWalletIndex

        }
    }
    Timer {id: timer}

    ListModel {id: diagnosticDataModel}

//    CopyPopup{id: copyPopup}
    DapMessagePopup{ id: messagePopup}

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
    DapNodeVersionPopup
    {
        id: messagePopupUpdateNode

        onSignalAccept:
        {
            if(accept)
            {
                console.log("Try download node. url: ", settingsModule.getUrlUpload())

                //TODO: It is necessary to find out the reason for the crash in the absence of a browser. This may have been fixed in QT 6.7.
                try
                {
                    Qt.openUrlExternally(settingsModule.getUrlUpload());
                }
                catch(error)
                {
                    console.log("ХХХХХ ---- An unforeseen situation has arisen. There are probably problems in the OS with browser settings. ----- ХХХХХ", error)
                }
            }
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
        z: 9
    }

    DapWalletsDuplicatePopup{
        id: walletsDuplicatePopup
        anchors.fill: parent
        visible: false
        z: 9
    }

    DapRemoveWalletPopup{
        id: removeWalletPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapRemoveOrderPopup{
        id: removeOrderPopup
        anchors.fill: parent
        visible: false
        z: 10
    }

    DapFirstSelectMode{
        id: firstSelectNodeModePopup
        anchors.fill: parent
        visible: false
        z: 20
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

    /// TODO Restore when you need the VPN tab. Fix the QNetworkAccessManager crash
    // VPNOrdersController
    // {
    //     id: vpnOrdersController
    // }



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
        ListElement { tag: "Master Node"
            name: qsTr("Master Node")
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

            append ({ tag: "DEX",
                name: qsTr("DEX Beta"),
                bttnIco: "icon_exchange.svg",
                showTab: true,
                page: "qrc:/screen/desktop/Stock/DapStockTab.qml"})

            append ({ tag: "TX explorer",
                name: qsTr("TX explorer"),
                bttnIco: "icon_history.svg",
                showTab: true,
                page: "qrc:/screen/desktop/History/DapHistoryTab.qml"})

            if(app.getNodeMode() === 0) //LOCAL MODE
            {

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

                append ({ tag: "Master Node",
                    name: qsTr("Master Node"),
                    bttnIco: "icon_master_node.svg",
                    showTab: true,
                    page: "qrc:/screen/desktop/MasterNode/DapMasterNodeTab.qml"})

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

            }

            append ({ tag: "Settings",
                name: qsTr("Settings"),
                bttnIco: "icon_settings.svg",
                showTab: true,
                page: "qrc:/screen/desktop/Settings/DapSettingsTab.qml"})

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
//                        onEntered: canCompactLeftMenu ? mainRowLayout.expandOrCompress(true) : {}
//                        onExited: canCompactLeftMenu ? mainRowLayout.expandOrCompress(false) : {}
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
        height: 42
    }


    DropShadow {
        anchors.fill: networksPanel
        source: networksPanel
        horizontalOffset: currTheme.hOffset
        verticalOffset: -7
        radius: 8
        color: currTheme.shadowColor
        smooth: true
        opacity: 0.7
        samples: 10
        cached: true
    }


    Rectangle {
        id: whiteTopBorderNetPanel
        anchors.left: networksPanel.left
        anchors.right: networksPanel.right
        anchors.bottom: networksPanel.top
        anchors.topMargin: -2
        height: 2
//        color: currTheme.reflection

        gradient: Gradient {
            GradientStop { position: 0.0; color: currTheme.mainBackground }
            GradientStop { position: 1.0; color: currTheme.reflectionLight }
        }
    }



    Component.onCompleted:
    {
        if(!app.getDontShowNodeModeFlag())
            firstSelectNodeModePopup.show()

        if(app.getNodeMode() === 0) //local
            dAppsModule.getListPlugins();

        if (logicMainApp.menuTabStates)
            logicMainApp.loadSettingsTab()
    }

    Connections
    {
        target: dapNotifyController

        function onNotifySocketStateChanged(state)
        {
            logicMainApp.rcvStateNotify(state)
        }
    }

    Connections
    {
        target: settingsModule

        function onSigVersionInfo(versionResult)
        {
            var jsonDocument = JSON.parse(versionResult)

            if(jsonDocument.hasUpdate && jsonDocument.message === "Reply version")
                logicMainApp.rcvNewVersion(settingsModule.dashboardVersion, jsonDocument)
            else if(!jsonDocument.hasUpdate && jsonDocument.message === "Reply version")
                console.log("You have the latest version installed. Current version: ", settingsModule.dashboardVersion)
            else
                console.log("The version value cannot be retrieved. Reply: ", jsonDocument.message)
        }

        function onSignalIsNeedInstallNode(isNeed, url)
        {
            console.log("onSignalIsNeedInstallNode", isNeed, url)
            if(isNeed)
            {
                settingsModule.nodeUpdateType = 5
                settingsModule.setNeedDownloadNode();
                openPopupUpdateNode()
            }
        }

        function onNeedNodeUpdateSignal()
        {
            openPopupUpdateNode()
        }
    }

    FontMetrics {
        id: metrics
    }

    function getWidth(font, text)
    {
        var maxStr = ""
        var count = text.length
        metrics.font = font

        var widthStr = metrics.boundingRect(text).width + 60
        return widthStr
    }

    function showInfoNotification(text, icon)
    {
        var widthWindow = getWidth(dapMainWindow.infoItem.textComponent.font, text)
        dapMainWindow.infoItem.showInfo(
            widthWindow,0,
            dapMainWindow.width*0.5,
            8,
            text,
            "qrc:/Resources/" + pathTheme + "/icons/other/" + icon)
    }

    Connections
    {
        target: dapServiceController

        function onTransactionRemoved(rcvData)
        {
            var jsonDocument = JSON.parse(rcvData)
            var result = jsonDocument.result
            var widthWindow = getWidth(dapMainWindow.infoItem.textComponent.font, result)
            var icon = "check_icon.png"
            if(result === qsTr("Nothing has been deleted."))
            {
                icon = "no_icon.png"
            }

            dapMainWindow.infoItem.showInfo(
                widthWindow,0,
                dapMainWindow.width*0.5,
                8,
                result,
                "qrc:/Resources/" + pathTheme + "/icons/other/" + icon)
        }

        function onSignalTokensListReceived(tokensResult)
        {
            console.log("TokensListReceived")
            logicMainApp.rcvTokens(tokensResult)
        }

        function onRcvWebConenctRequest(site, index)
        {
            logicMainApp.rcvWebConnectRequest(site, index)
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

    Connections{
        target: walletModule
        function onDuplicateWalletsAppeared(wallets)
        {
            walletsDuplicatePopup.duplicateModel.append(wallets)
            walletsDuplicatePopup.show()
        }
    }

    onShowPopupUpdateNode:
    {
        openPopupUpdateNode()
    }

    function openPopupUpdateNode()
    {
        var type = settingsModule.nodeUpdateType
        if(type === 1)
        {
            messagePopupUpdateNode.dapButtonCancel.visible = true
            messagePopupUpdateNode.dapButtonOk.visible = false
            messagePopupUpdateNode.dapButtonCancel.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonCancel.textButton = qsTr("Close")
            messagePopupUpdateNode.textMessage.font = mainFont.dapFont.regular14
            messagePopupUpdateNode.height = 210
            var header = qsTr("Node latest supported version is installed")
            var text = qsTr("You’re using the most up-to-date version of node.")
            messagePopupUpdateNode.smartOpenVersion(header, "", "", text)
        }
        else if(type === 2)
        {
            messagePopupUpdateNode.height = 235
            messagePopupUpdateNode.dapButtonCancel.visible = false
            messagePopupUpdateNode.dapButtonOk.visible = true
            messagePopupUpdateNode.dapButtonOk.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonOk.textButton = qsTr("Update")

            messagePopupUpdateNode.textMessage.font = mainFont.dapFont.regular14
            var header = "<font color='" + currTheme.red + "'>" + qsTr("Current node version is unsupported") + "</font>"
            var text = qsTr("Your current node version ") + settingsModule.nodeVersion + qsTr(" is not compatible. Please update to the latest supported version to continue.")
            messagePopupUpdateNode.smartOpenVersion(header, "", "", text)
        }
        else if(type === 3)
        {
            messagePopupUpdateNode.dapButtonOk.visible = true
            messagePopupUpdateNode.dapButtonOk.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonOk.textButton = qsTr("Downgrade")

            messagePopupUpdateNode.dapButtonCancel.visible = true
            messagePopupUpdateNode.dapButtonCancel.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonCancel.textButton = qsTr("Cancel")

            messagePopupUpdateNode.textMessage.font = mainFont.dapFont.regular14
            var header = "<font color='" + currTheme.textColorYellow + "'>" + qsTr("Incompatible node version") + "</font>"
            var text = qsTr("You’re using version ") + settingsModule.nodeVersion + qsTr(", which isn’t tested with this application and may cause issues. Downgrade to a compatible version?")
            messagePopupUpdateNode.smartOpenVersion(header, "", "", text)
        }
        else if(type === 4) // Update
        {
            messagePopupUpdateNode.dapButtonOk.visible = true
            messagePopupUpdateNode.dapButtonOk.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonOk.textButton = qsTr("Update")

            messagePopupUpdateNode.dapButtonCancel.visible = true
            messagePopupUpdateNode.dapButtonCancel.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonCancel.textButton = qsTr("Cancel")

            messagePopupUpdateNode.height = 220
            messagePopupUpdateNode.textMessage.font = mainFont.dapFont.regular14
            var header = "<font color='" + currTheme.сrayola + "'>" + qsTr("Node new version is available") + "</font>"
            var curVer = settingsModule.nodeVersion
            var maxVer = settingsModule.getMaxNodeVersion()
            var text = qsTr("You’re using version ") + curVer + qsTr(". Version ") + "<font color='"  + currTheme.сrayola + "'><b>" + maxVer + "</b></font>" + qsTr(" is now available!")
            messagePopupUpdateNode.smartOpenVersion(header, "", "", text)
        }
        else if(type === 5) //Download
        {
            messagePopupUpdateNode.dapButtonCancel.visible = false
            messagePopupUpdateNode.dapButtonOk.visible = true
            messagePopupUpdateNode.dapButtonOk.fontButton = mainFont.dapFont.regular14
            messagePopupUpdateNode.dapButtonOk.textButton = "Download"

            messagePopupUpdateNode.textMessage.font = mainFont.dapFont.regular14
            var header = "<font color='" + currTheme.red + "'>" + qsTr("Cellframe node is missing") + "</font>"
            var text = qsTr("Your device is missing cellframe-node. Click \"Download\" to download the latest supported version.")
            messagePopupUpdateNode.smartOpenVersion(header, "", "", text)
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
 ##^##*/
