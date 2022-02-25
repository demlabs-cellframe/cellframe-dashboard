import QtQuick 2.12
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
    readonly property string historyScreen: "qrc:/screen/desktop/History/DapHistoryTab.qml"
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

    //Tabs

    property string menuTabStates: ""
    Settings { property alias menuTabStates: dapMainPage.menuTabStates }
    signal menuTabChanged()
    signal tabUpdate(var tag, var status)
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
        Component.onCompleted:
        {
            append({
                       name: qsTr("Dark theme"),
                       source: darkTheme
                   })
        }
    }

    ListModel{
        id:modelAppsTabStates

        ListElement { tag: "Plugin"
            name: qsTr("Plugin")
            show: true }
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

        Component.onCompleted:
        {
            mainButtonsModel = Logic.initButtonsModel(mainButtonsModel, modelMenuTabStates)
            mainButtonsModel = Logic.initButtonsModel(mainButtonsModel, modelAppsTabStates)
            pluginsTabChanged(true,false,"")
        }
    }


    property var mainButtonsModel: [
        {
            "name": qsTr("Wallet"),
            "tag": "Wallet",
            "bttnIco": "icon_wallet.png",
            "showTab": true
        },
        {
            "name": qsTr("Exchange"),
            "tag": "Exchange",
            "bttnIco": "icon_exchange.png",
            "showTab": true
        },
        {
            "name": qsTr("TX Explorer"),
            "tag": "TX Explorer",
            "bttnIco": "icon_history.png",
            "showTab": true
        },
        {
            "name": qsTr("Certificates"),
            "tag": "Certificates",
            "bttnIco": "icon_certificates.png",
            "showTab": true
        },
        {
            "name": qsTr("Tokens"),
            "tag": "Tokens",
            "bttnIco": "icon_tokens.png",
            "showTab": true
        },
        {
            "name": qsTr("VPN client"),
            "tag": "VPN client",
            "bttnIco": "vpn-client_icon.png",
            "showTab": true
        },
        {
            "name": qsTr("VPN service"),
            "tag": "VPN service",
            "bttnIco": "icon_vpn.png",
            "showTab": true
        },
        {
            "name": qsTr("Console"),
            "tag": "Console",
            "bttnIco": "icon_console.png",
            "showTab": true
        },
        {
            "name": qsTr("Logs"),
            "tag": "Logs",
            "bttnIco": "icon_logs.png",
            "showTab": true
        },
        {
            "name": qsTr("dApps"),
            "tag": "dApps",
            "bttnIco": "icon_daaps.png",
            "showTab": true
        },
        {
            "name": qsTr("Settings"),
            "tag": "Settings",
            "bttnIco": "icon_settings.png",
            "showTab": true
        }
    ]



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
                        {
                            Qt.openUrlExternally(toolTip.text);

                        }
                    }
                }

                ListView {
                    id: mainButtonsList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 0
                    clip: true
                    //interactive: false
                    model: mainButtonsModel

                    delegate: DapMenuButton {}
                }

            }
        }

        Rectangle {
            id: mainScreen
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: currTheme.backgroundMainScreen

            StackLayout {
                id: mainScreenStack
                currentIndex: mainButtonsList.currentIndex
                anchors.fill: parent
                StackView { id: dapWalletPage; initialItem: dashboardScreen}
                StackView { id: exchangePage; initialItem: underConstructionsScreen}
                StackView { id: daphistoryPage; initialItem: historyScreen}
                StackView { id: dapCertificatesPage; initialItem: certificatesScreen}
                StackView { id: dapTokensPage; initialItem: underConstructionsScreen}
                StackView { id: dapVPNClientPage; initialItem: vpnClientScreen}
                StackView { id: dapVPNServicePage; initialItem: vpnServiceScreen}
                StackView { id: dapConsolePage; initialItem: consoleScreen}
                StackView { id: dapLogsPage; initialItem: logsScreen}
                StackView { id: dapApps; initialItem: appsScreen}
                StackView { id: dapSettingsPage; initialItem: settingsScreen}

//                StackView { id: dapTestPage; initialItem: testScreen}
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
    {
        updateMenuTabStatus()
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

//        for (var i = 0; i < modelAppsTabStates.count; ++i)
//        {
//            datamodel.push(modelAppsTabStates.get(i))
//            console.log(modelAppsTabStates.get(i).tag,
//                            "show", modelAppsTabStates.get(i).show)
//        }

        menuTabStates = JSON.stringify(datamodel)
    }
    onPluginsTabChanged:
    {

    }

    Component.onCompleted: {
        dapServiceController.requestToService("DapGetListNetworksCommand")
        dapServiceController.requestToService("DapGetWalletsInfoCommand")
        dapServiceController.requestToService("DapGetNetworksStateCommand")

        if (menuTabStates)
        {
            console.log("loading menuTabStates", menuTabStates)
            var dataModel = JSON.parse(menuTabStates)
            Logic.loadSettingsInTabs(modelMenuTabStates, dataModel)
            modelAppsTabStates = Logic.loadSettingsInTabs(modelAppsTabStates, dataModel)
        }
        console.log()
    }

    Connections {
        target: dapServiceController

        onNetworksListReceived: {
            dapServiceController.setCurrentNetwork(Logic.returnCurrentNetwork(networksList))
            _dapModelNetworks = Logic.rcvNetworksList(networksList, parent)
        }

        onWalletsReceived: {
            _dapModelWallets = Logic.rcvWalletList(walletList, parent)
            modelWalletsUpdated();
        }
        onOrdersReceived:{
            _dapModelOrders = Logic.rcvOrderList(orderList, parent)
            modelOrdersUpdated();
        }
    }

    Connections{
        target: pluginsManager
        onRcvListPlugins:
        {
            _dapModelPlugins = Logic.rcvPluginList(m_pluginsList, parent)

            modelPluginsUpdated()
            updateModelAppsTab() // TODO
        }
    }
}
