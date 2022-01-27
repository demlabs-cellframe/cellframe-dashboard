import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import "../screen"
import "qrc:/resources/QML"
import "../screen/controls"
import "../resources/theme"

FocusScope {
    id: dapMainPage

    ///@detalis Path to the tabs.
    readonly property string dashboardScreen: "qrc:/screen/" + device + "/Dashboard/DapDashboardTab.qml"
    readonly property string walletScreen: "qrc:/screen/" + device + "/Wallet/WalletPage.qml"
    readonly property string exchangeScreen: "qrc:/screen/" + device + "/Exchange/DapExchangeTab.qml"
    readonly property string historyScreen: "qrc:/screen/" + device + "/History/DapHistoryTab.qml"
    readonly property string vpnServiceScreen: "qrc:/screen/" + device + "/VPNService_New/DapVPNServiceTab.qml"
    readonly property string vpnClientScreen: "qrc:/screen/" + device + "/VPNClient/VPNClientPage.qml"
    readonly property string settingsScreen: "qrc:/screen/" + device + "/Settings/DapSettingsTab.qml"
    readonly property string logsScreen: "qrc:/screen/" + device + "/Logs/DapLogsTab.qml"
    readonly property string consoleScreen: "qrc:/screen/" + device + "/Console/DapConsoleTab.qml"
    readonly property string certificatesScreen: "qrc:/screen/" + device + "/Certificates/DapCertificatesMainPage.qml"
    readonly property string underConstructionsScreen: "qrc:/screen/" + device + "/UnderConstructions.qml"
    readonly property string testScreen: "qrc:/screen/" + device + "/Test/TestPage.qml"

    readonly property QtObject dapMainFonts: DapFontRoboto {}
    property alias _dapQuicksandFonts: quicksandFonts

    property var _dapWallets: []

    property ListModel _tokensModel

    Dark { id: darkTheme }
    Light { id: lightTheme }

    property string pathTheme: "BlackTheme"

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme

    property var _dapWalletsModel: []
    property var _dapNetworksModel: []
    property var _dapPluggins: []

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
            "name": qsTr("Settings"),
            "bttnIco": "icon_settings.png"
        },
        {
            "name": qsTr("Test"),
            "bttnIco": "icon_settings.png"
        }
    ]

    DapFontQuicksand {
        id: quicksandFonts
    }

    Rectangle {
        anchors.fill: parent
        color: currTheme.backgroundPanel
    }

    RowLayout {
        id: mainRowLayout
        anchors.fill: parent

        Rectangle {
            id: leftMenuBackGrnd
            Layout.fillHeight: true
            Layout.bottomMargin: 7
            width: 200
            radius: 20
            color: currTheme.backgroundMainScreen

            visible: false

            Rectangle {
                width: 30
                height: 30
                anchors {
                    top: parent.top
                    right: parent.right
                }
                color: currTheme.backgroundMainScreen
            }
            Rectangle {
                width: 30
                height: 30
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                color: currTheme.backgroundMainScreen
            }

            ColumnLayout {
                id: mainButtonsColumn
                anchors.fill: parent

                Item {
                    id: logo
                    Layout.margins: 10
                    width: 111 * pt
                    height: 24 * pt
                    Image {
                        id: logoImg
                        anchors.fill: parent
                        source: "qrc:/resources/icons/BlackTheme/cellframe-logo-dashboard.png"
                    }
                }

                ListView {
                    id: mainButtonsList
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 5
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

                StackView { id: dapWalletPage; Component.onCompleted: push(walletScreen)}
                StackView { id: exchangePage; Component.onCompleted: push(underConstructionsScreen)}
                StackView { id: daphistoryPage; Component.onCompleted: push(underConstructionsScreen)}
                StackView { id: dapCertificatesPage; Component.onCompleted: push(certificatesScreen)}
                StackView { id: dapTokensPage; Component.onCompleted: push(underConstructionsScreen)}
                StackView { id: dapVPNClientPage; Component.onCompleted: push(vpnClientScreen)}
                StackView { id: dapVPNServicePage; Component.onCompleted: push(vpnServiceScreen)}
                StackView { id: dapConsolePage; Component.onCompleted: push(consoleScreen)}
                //StackView { id: dapLogsPage; Component.onCompleted: push(underConstructionsScreen)}
                StackView { id: dapSettingsPage; Component.onCompleted: push(settingsScreen)}

                StackView { id: dapTestPage; Component.onCompleted: push(testScreen)}
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

    Component.onCompleted: {
        dapServiceController.requestToService("DapGetListNetworksCommand")
        dapServiceController.requestToService("DapGetWalletsInfoCommand")
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
    }
}
