import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"
import "logic"

DapPage
{
    property string currentString: ""
    property string currentStatus: "All statuses"
    property string currentPeriod: "all time"
    property bool isCurrentRange: false
    readonly property string infoAboutTx: path + "/History/DapHistoryRightPanelInfoTx.qml"

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property int lastHistoryLength: 0

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen

    id: historyTab

//    ListModel{id: modelHistory}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}
    ListModel{id: detailsModel}

    Component{id: emptyRightPanel; Item{}}

    QtObject {
        id: navigator

        function txInfo()
        {
            historyScreen.dapHistoryRightPanel.visible = false
            dapRightPanelFrame.visible = true
            dapRightPanel.pop()
            dapRightPanel.push(infoAboutTx)
        }

        function clear()
        {
            dapRightPanel.clear()
            dapRightPanelFrame.visible = false
            dapRightPanel.push(emptyRightPanel)
            historyScreen.dapHistoryRightPanel.visible = true
        }
    }

    LogicTxExplorer
    {
        id: logicExplorer
    }

    Timer {
        id: updateHistoryTimer
        interval: logicMainApp.autoUpdateHistoryInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("HISTORY TIMER TICK")
            logicExplorer.updateWalletHistory(false, 0)
        }
    }

    dapHeader.initialItem: DapSearchTopPanel
        {
            id:historyTopPanel
            onFindHandler: {
                console.log(text)
                currentString = text
                historyWorker.setFilterString(text)
            }
        }

    dapScreen.initialItem: DapHistoryScreen
    {
        id:historyScreen
        dapHistoryRightPanel.onCurrentStatusSelected: {

                currentStatus = status
                historyWorker.setCurrentStatus(status)
        }

        dapHistoryRightPanel.onCurrentPeriodSelected: {

                currentPeriod = period
                isCurrentRange = isRange

                var data = [period, isRange]

                historyWorker.setCurrentPeriod(data)
            }
    }

    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

    Connections
    {
        target: dapMainWindow
        function onModelWalletsUpdated()
        {
            if (logicMainApp.currentWalletIndex >=0 ||
                logicMainApp.currentWalletIndex < dapModelWallets.count)
                historyWorker.setWalletName(
                    dapModelWallets.get(logicMainApp.currentWalletIndex).name)

            logicExplorer.updateWalletHistory(false, true)
        }
    }

    Component.onCompleted:
    {
        historyWorker.setCurrentStatus(currentStatus)

        historyWorker.setLastActions(false)
        if (logicMainApp.currentWalletIndex >=0 ||
            logicMainApp.currentWalletIndex < dapModelWallets.count)
            historyWorker.setWalletName(
                dapModelWallets.get(logicMainApp.currentWalletIndex).name)

        logicExplorer.updateWalletHistory(false, 1)

        if (!updateHistoryTimer.running)
            updateHistoryTimer.start()
    }

    Component.onDestruction:
    {
        updateHistoryTimer.stop()
    }
}
