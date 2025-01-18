import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "Logic"
import "../History/logic"
import "../controls"

Page {

    property bool isRcvHistory: false
    property bool isRcvWallets: false
    id: walletsPage
    title: qsTr("Wallet")
    hoverEnabled: true
    background: Rectangle {color: currTheme.mainBackground }

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property date lastDate: new Date(0)
    property date prevDate: new Date(0)


    state: "WALLETDEFAULT"

    ListModel{id: tokenModel}

    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    LogicTxExplorer{id: logicExplorer}
    LogicWallet{id: logicWallet}

    GetStartedWallet{
        id: getStartedScreen
        anchors.fill: parent
    }

    WalletsShow{
        id: walletsShow
        anchors.fill: parent
    }

    WalletProtected
    {
        id: walletProtected
        anchors.fill: parent
    }

    states:
    [
        State
        {
            name: "WALLETDEFAULT"
            PropertyChanges
            {
                target: getStartedScreen
                visible: true
            }
            PropertyChanges
            {
                target: walletsShow
                visible: false
            }
            PropertyChanges
            {
                target: walletProtected
                visible: false
            }
        },
        State
        {
            name: "WALLETSHOW"
            PropertyChanges
            {
                target: getStartedScreen
                visible: false
            }
            PropertyChanges
            {
                target: walletsShow
                visible: true
            }
            PropertyChanges
            {
                target: walletProtected
                visible: false
            }
        },
        State
        {
            name: "WALLETPROTECTED"
            PropertyChanges
            {
                target: getStartedScreen
                visible: false
            }
            PropertyChanges
            {
                target: walletsShow
                visible: false
            }
            PropertyChanges
            {
                target: walletProtected
                visible: true
            }
        }
    ]

    Component.onCompleted:
    {
        walletModule.statusProcessing = true
        txExplorerModule.statusProcessing = true

        modelHistory.setNetworkFilter(modulesController.getCurrentNetwork()) // Need change to currentNetwork
        modelHistory.setFilterString()
        modelHistory.setCurrentStatus("All statuses")
        modelHistory.setLastActions(false)

        logicWallet.updateWalletModel()
        isRcvWallets = tokenModel.count
    }

    Component.onDestruction:
    {
        walletModule.statusProcessing = false
        txExplorerModule.statusProcessing = false
    }

    Connections
    {
        target: walletModule
        function onCurrentWalletChanged()
        {
            logicWallet.updateWalletModel()
        }

        function onWalletsModelChanged()
        {
            logicWallet.updateWalletModel()
        }
    }
}
