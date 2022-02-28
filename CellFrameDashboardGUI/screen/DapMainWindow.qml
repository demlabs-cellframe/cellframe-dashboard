import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

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


    property ListModel _tokensModel
    property ListModel _dapModelPlugins
    property ListModel _dapModelOrders

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

    property var mainButtonsModel: [
        {
            "name": qsTr("Wallet"),
            "bttnIco": "icon_wallet.png"
        },
        {
            "name": qsTr("Exchange"),
            "bttnIco": "icon_exchange.png"
        },
        {
            "name": qsTr("TX Explorer"),
            "bttnIco": "icon_history.png"
        },
        {
            "name": qsTr("Certificates"),
            "bttnIco": "icon_certificates.png"
        },
        {
            "name": qsTr("Tokens"),
            "bttnIco": "icon_tokens.png"
        },
        {
            "name": qsTr("VPN client"),
            "bttnIco": "vpn-client_icon.png"
        },
        {
            "name": qsTr("VPN service"),
            "bttnIco": "icon_vpn.png"
        },
        {
            "name": qsTr("Console"),
            "bttnIco": "icon_console.png"
        },
        {
            "name": qsTr("Logs"),
            "bttnIco": "icon_logs.png"
        },
        {
            "name": qsTr("dApps"),
            "bttnIco": "icon_daaps.png"
        },
        {
            "name": qsTr("Settings"),
            "bttnIco": "icon_settings.png"
        },
        {
            "name": qsTr("Test"),
            "bttnIco": "icon_settings.png"
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

                    delegate: DapMenuButton { }
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
                StackView { id: dapWalletPage; initialItem: walletScreen}
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

                //StackView { id: dapTestPage; initialItem: testScreen}
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

    // JS functions
    function getWallets(tempWallets) {

        for (let i = 0; i < tempWallets.length; i++) {
            _dapWallets.push(tempWallets[i])
        }

        for (let j = 0; j < _dapWallets.length; j++) {
            _dapWalletsModel.push({
                                      "name": _dapWallets[j].Name,
                                      "balance": _dapWallets[j].Balance,
                                      "icon" : _dapWallets[j].Icon,
                                      "address" : _dapWallets[j].Address,
                                      "networks": [],
                                      "tokens": []
                                  })

            for (let k = 0; k < _dapWallets[j].Networks.length; k++) {
                _dapWalletsModel[j].networks.push(_dapWallets[j].Networks[k])
            }

            for (let l = 0; _dapWallets[j].Tokens.length; l++) {
                _dapWalletsModel[j].tokens.push({
                                                       "name": _dapWallets[j].Tokens[l].Name,
                                                       "balance": _dapWallets[j].Tokens[l].Balance,
                                                       "emission": _dapWallets[j].Tokens[l].Emission,
                                                       "network": _dapWallets[j].Tokens[l].Network
                                                   })
                _tokensModel.append({
                                        name: _dapWallets[j].Tokens[l].Name,
                                        balance: _dapWallets[j].Tokens[l].Balance,
                                        emission: _dapWallets[j].Tokens[l].Emission,
                                        network: _dapWallets[j].Tokens[l].Network
                                    })
            }
        }
    }

    function getWalletHistory(index)
    {
        var counter = 0

        if (index < 0 || index >= _dapWalletsModel.count)
            return counter

        var model = _dapWalletsModel[index].networks
        var name = _dapWalletsModel[index].name

        for (var i = 0; i < model.count; ++i)
        {
            var network = model[i].name
            var address = model[i].address

            if (model[i].chains.count > 0)
            {
                for (var j = 0; j < model[i].chains.count; ++j)
                {
                    var chain = model[i].chains[i].name

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


    Component.onCompleted: {
        dapServiceController.requestToService("DapGetListNetworksCommand")
        dapServiceController.requestToService("DapGetWalletsInfoCommand")
        dapServiceController.requestToService("DapGetNetworksStateCommand")
    }

    Connections {
        target: dapServiceController

        onNetworksListReceived: {
            console.info("NETWORKS -> ", JSON.stringify(networkList))
            for (let i = 0; i < networkList.length; i++) {
                _dapNetworksModel.push(networkList[i])
                console.warn("_dapNetworksModel[i] ->",_dapNetworksModel[i])
            }
        }

        onWalletsReceived: {
            console.info("WALLETS -> ", JSON.stringify(walletList))
            getWallets(walletList)
        }
        onOrdersReceived:
        {
            //_dapModelOrders = Logic.rcvOrderList(orderList, parent)
            _dapModelOrders = globalLogic.rcvOrderList(orderList, parent)
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
