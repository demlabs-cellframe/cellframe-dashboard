import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"
import "logic"
import "../Wallets"

Page
{
    id: historyTab

    title: qsTr("Transactions")
    background: Rectangle {color: currTheme.mainBackground }
    hoverEnabled: true

    property bool isRcvHistory: false
    property string currentStatus: qsTr("All statuses")
    readonly property string infoAboutTx: pathForms + "/History/DapHistoryRightPanelInfoTx.qml"

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property alias dapHistoryScreen: historyScreen

//    ListModel{id: modelHistory}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}
    ListModel{id: detailsModel}

    LogicTxExplorer
    {
        id: logicExplorer
    }


    DapHistoryScreen
    {
        id:historyScreen
        anchors.fill: parent
        dapHistoryTopPanel.onSelected: {
            currentStatus = status
            modelHistory.setCurrentStatus(currentStatus)
        }
    }

    WalletProtected
    {
        anchors.fill: parent
        visible: !historyScreen.visible
    }

    Connections
    {
        target: walletModule
        function onCurrentWalletChanged()
        {
            checkProtected()
        }

        function onWalletsModelChanged()
        {
            checkProtected()
        }
    }

    Component.onCompleted:
    {
        checkProtected()
    }

    function checkProtected()
    {
        historyScreen.visible = walletModule.checkWalletLocked(walletModule.currentWalletName) ? false : true
    }

}
