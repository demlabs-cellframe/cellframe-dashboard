import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.1

import "qrc:/widgets"
import "../screen"
import "qrc:/resources/QML"
import "../screen/controls"
import "../screen/Logic/Logic.js" as Logic


FocusScope {
    id: dapMainPage

    ///@detalis Path to the tabs.
    readonly property string dashboardScreen: "qrc:/screen/desktop/Dashboard/DapDashboardTab.qml"
    readonly property string walletScreen: "qrc:/screen//Wallet/WalletPage.qml"
    readonly property string exchangeScreen: "qrc:/screen/desktop/Exchange/DapExchangeTab.qml"
    readonly property string historyScreen: "qrc:/screen/desktop/History/TXHistoryPage.qml"
    readonly property string certificatesScreen: "qrc:/screen/desktop/Certificates/DapCertificatesMainPage.qml"
    readonly property string tokensScreen: "qrc:/screen/desktop/Tokens/DapTokensTab.qml"
    readonly property string vpnClientScreen: "qrc:/screen/desktop/VPNClient/VPNClientPage.qml"
    readonly property string vpnServiceScreen: "qrc:/screen/desktop/VPNService/DapVPNServiceTab.qml"
    readonly property string consoleScreen: "qrc:/screen/desktop/Console/DapConsoleTab.qml"
    readonly property string logsScreen: "qrc:/screen/desktop/Logs/DapLogsTab.qml"
    readonly property string appsScreen: "qrc:/screen/desktop/dApps/DapAppsTab.qml"
    readonly property string settingsScreen: "qrc:/screen/desktop/Settings/DapSettingsTab.qml"
    readonly property string underConstructionsScreen: "qrc:/screen/desktop/UnderConstructions.qml"
    readonly property string testScreen: "qrc:/screen/desktop/Test/TestPage.qml"
    readonly property QtObject dapMainFonts: DapFontRoboto {}

    signal updatePage(var index)

    //Tabs

    property string menuTabStates: ""
    Settings { property alias menuTabStates: dapMainPage.menuTabStates }
    signal menuTabChanged()
    signal pluginsTabChanged(var auto, var removed, var name)
    //

    property ListModel _tokensModel
    property ListModel _dapModelPlugins
    property ListModel _dapModelOrders
    property ListModel _dapModelNetworks
    property ListModel _dapModelWallets

    property var _dapWallets: []
    property var _dapWalletsModel: []
    property var _dapNetworksModel: []

    signal modelWalletsUpdated()
    signal modelOrdersUpdated()
    signal modelPluginsUpdated()

    ListModel {
        id: themes
        ListElement{
            name: "Dark theme"
            /*source: darkTheme*/}
    }

    ListModel{
        id:modelAppsTabStates
    }

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
        ListElement { tag: "Wallet"
            name: qsTr("Wallet")
            bttnIco: "icon_wallet.png"
            showTab: true}
        ListElement { tag: "Exchange"
            name: qsTr("Exchange")
            bttnIco: "icon_exchange.png"
            showTab: true}
        ListElement { tag: "TX Explorer"
            name: qsTr("TX Explorer")
            bttnIco: "icon_history.png"
            showTab: true}
        ListElement { tag: "Certificates"
            name: qsTr("Certificates")
            bttnIco: "icon_certificates.png"
            showTab: true}
        ListElement { tag: "Tokens"
            name: qsTr("Tokens")
            bttnIco: "icon_tokens.png"
            showTab: true}
        ListElement { tag: "VPN client"
            name: qsTr("VPN client")
            bttnIco: "vpn-client_icon.png"
            showTab: true}
        ListElement { tag: "VPN service"
            name: qsTr("VPN service")
            bttnIco: "icon_vpn.png"
            showTab: true}
        ListElement { tag: "Console"
            name: qsTr("Console")
            bttnIco: "icon_console.png"
            showTab: true}
        ListElement { tag: "Logs"
            name: qsTr("Logs")
            bttnIco: "icon_logs.png"
            showTab: true}
        ListElement { tag: "dApps"
            name: qsTr("dApps")
            bttnIco: "icon_daaps.png"
            showTab: true}
        ListElement { tag: "Settings"
            name: qsTr("Settings")
            bttnIco: "icon_settings.png"
            showTab: true}

        Component.onCompleted:
            globalLogic.initButtonsModel(modelMenuTab, modelMenuTabStates)
    }

    Rectangle {
        anchors.fill: parent
        color: currTheme.backgroundPanel
    }

    RowLayout {
        id: mainRowLayout
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: leftMenuBackGrnd
            Layout.fillHeight: true
            Layout.bottomMargin: 7
            width: 180
            radius: 20
            color: currTheme.backgroundPanel

            //hide bottom radius element
            Rectangle
            {
                z:0
                width: leftMenuBackGrnd.radius
                color: currTheme.backgroundPanel
                anchors.bottom: leftMenuBackGrnd.bottom
                anchors.left: leftMenuBackGrnd.left
                anchors.top: leftMenuBackGrnd.top
            }
            //hide top radius element
            Rectangle{
                z:0
                height: currTheme.radiusRectangle
                anchors.top:leftMenuBackGrnd.top
                anchors.right: leftMenuBackGrnd.right
                anchors.left: leftMenuBackGrnd.left
                color: currTheme.backgroundPanel
            }

            ColumnLayout {
                id: mainButtonsColumn
                anchors.fill: parent
                spacing: 0

                Item {
                    id: logo
//                    Layout.margins: 10
                    width: parent.width * pt
                    height: 60 * pt

                    DapImageLoader{
                        innerWidth: 114 * pt
                        innerHeight: 24 * pt
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

                        parent: Overlay.overlay
                        x: width*0.5
                        y: height*0.5

                        contentItem: Text {
                                text: toolTip.text
                                font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
                            Qt.openUrlExternally(toolTip.text);
                    }
                }

                ListView {
                    id: mainButtonsList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 0
                    clip: true
                    //interactive: false
                    model: modelMenuTab

                    delegate: DapMenuButton {}
                }

            }
        }

        Rectangle {
            property bool isInit:false
            id: mainScreen
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: currTheme.backgroundMainScreen

            StackLayout {
                id: mainScreenStack
                currentIndex: mainButtonsList.currentIndex
                anchors.fill: parent

                //To add item to mainModel use mainModel.insert(<index>, <Item>) to know last position use mainModel.count
                Repeater {
                    model: ObjectModel {
                        id: mainModel
                        DapStackView { id: dapWalletPage;       }
                        DapStackView { id: exchangePage;        }
                        DapStackView { id: daphistoryPage;      }
                        DapStackView { id: dapCertificatesPage; }
                        DapStackView { id: dapTokensPage;       }
                        DapStackView { id: dapVPNClientPage;    }
                        DapStackView { id: dapVPNServicePage;   }
                        DapStackView { id: dapConsolePage;      }
                        DapStackView { id: dapLogsPage;         }
                        DapStackView { id: dapApps;             }
                        DapStackView { id: dapSettingsPage;     }
                    }
                }

                onCurrentIndexChanged: {if(mainScreen.isInit) updatePage(currentIndex+1)}
            }
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

    onMenuTabChanged:
        menuTabStates = globalLogic.updateMenuTabStatus(modelMenuTabStates, modelAppsTabStates)

    onPluginsTabChanged:
    {
        if(auto){
            for(var i = 0; i < modelAppsTabStates.count; i++){
                modelMenuTab.append({name: qsTr(modelAppsTabStates.get(i).name),
                                    tag: modelAppsTabStates.get(i).tag,
                                    page: modelAppsTabStates.get(i).path,
                                    bttnIco: "icon_certificates.png",
                                    showTab: modelAppsTabStates.get(i).show})

                var component = Qt.createComponent(modelAppsTabStates.get(i).path);
                var obj = component.createObject(mainModel);
                mainModel.append(obj)
            }
        }else{
            var index;
            if(removed){
                for(var i = 0; i < modelMenuTab.count; i++){
                    if(modelMenuTab.get(i).name === name){
                        modelMenuTab.remove(i);
                        mainModel.remove(i);
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

                        var component = Qt.createComponent(modelAppsTabStates.get(i).path);
                        var obj = component.createObject(mainModel);
                        mainModel.append(obj)
                        break;
                    }
                }
            }
        }
        menuTabStates = globalLogic.updateMenuTabStatus(modelMenuTabStates, modelAppsTabStates)
    }

    Component.onCompleted: {
        dapServiceController.requestToService("DapGetWalletsInfoCommand")
        dapServiceController.requestToService("DapGetNetworksStateCommand")

        if (menuTabStates){
            var dataModel = JSON.parse(menuTabStates)
            globalLogic.loadSettingsInTabs(modelMenuTabStates, dataModel)
        }
        initPages()
    }

    Connections {
        target: dapServiceController

        onNetworksListReceived: {
            _dapModelNetworks = globalLogic.rcvNetworksList(networksList, parent)
        }

        onWalletsReceived: {
            _dapModelWallets = globalLogic.rcvWalletList(walletList, parent)
            modelWalletsUpdated();
        }
        onOrdersReceived:
        {
            _dapModelOrders = globalLogic.rcvOrderList(orderList, parent)
            modelOrdersUpdated();
        }
    }

    Connections{
        target: pluginsManager
        onRcvListPlugins:
        {
            _dapModelPlugins = globalLogic.rcvPluginList(m_pluginsList, parent)
            modelPluginsUpdated()
            updateModelAppsTab()
        }
    }

    function initPages()
    {
        dapWalletPage.setInitialItem(dashboardScreen)
        exchangePage.setInitialItem(underConstructionsScreen)
        daphistoryPage.setInitialItem(historyScreen)
        dapCertificatesPage.setInitialItem(certificatesScreen)
        dapTokensPage.setInitialItem(underConstructionsScreen)
        dapVPNClientPage.setInitialItem(vpnClientScreen)
        dapVPNServicePage.setInitialItem(vpnServiceScreen)
        dapConsolePage.setInitialItem(consoleScreen)
        dapLogsPage.setInitialItem(logsScreen)
        dapApps.setInitialItem(appsScreen)
        dapSettingsPage.setInitialItem(settingsScreen)
        mainScreen.isInit = true
    }

    function updateModelAppsTab() //create model apps from left menu tab
    {
        if(modelAppsTabStates.count)
        {
            for(var i = 0; i < _dapModelPlugins.count; i++)
            {
                var indexCreate;
                for(var j = 0; j < modelAppsTabStates.count; j++)
                {
                    if(_dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name && _dapModelPlugins.get(i).status !== "1")
                    {

                        pluginsTabChanged(false, true, modelAppsTabStates.get(j).name)
                        modelAppsTabStates.remove(j);
                        j--;
                    }
                    else if(_dapModelPlugins.get(i).status === "1" && _dapModelPlugins.get(i).name !== modelAppsTabStates.get(j).name)
                    {
                        indexCreate = i;
                    }
                    else if(_dapModelPlugins.get(i).status === "1" && _dapModelPlugins.get(i).name === modelAppsTabStates.get(j).name)
                    {
                        indexCreate = -1;
                        break
                    }
                }

                if(indexCreate >= 0)
                {
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:_dapModelPlugins.get(indexCreate).name,
                                               path: _dapModelPlugins.get(indexCreate).path,
                                               verified:_dapModelPlugins.get(indexCreate).verifed,
                                               show:true})

                    pluginsTabChanged(false, false, _dapModelPlugins.get(indexCreate).name)
                    break
                }
            }
        }
        else
        {
            var first = false
            if (menuTabStates && !modelAppsTabStates.count)
                first = true

            for(var i = 0; i < _dapModelPlugins.count; i++)
            {
                if(_dapModelPlugins.get(i).status === "1")
                {
                    modelAppsTabStates.append({tag: "Plugin",
                                               name:_dapModelPlugins.get(i).name,
                                               path: _dapModelPlugins.get(i).path,
                                               verified:_dapModelPlugins.get(i).verifed,
                                               show:true})
                }
            }
            if(first)
            {
                var dataModel = JSON.parse(menuTabStates)
                globalLogic.loadSettingsInTabs(modelAppsTabStates, dataModel)
            }
            if(modelMenuTab.count)
                pluginsTabChanged(true,false,"")
        }
    }
}
