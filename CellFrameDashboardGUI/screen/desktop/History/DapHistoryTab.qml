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

    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property int lastHistoryLength: 0

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen

    id: historyTab

    ListModel{id: modelHistory}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    LogicTxExplorer
    {
        id: logicExplorer
    }

    Timer {
        id: updateHistoryTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("HISTORY TIMER TICK")
            logicExplorer.updateWalletHistory(false)
        }
    }

    dapHeader.initialItem: DapSearchTopPanel
        {
            id:historyTopPanel
            onFindHandler: {
                currentString = text
                logicExplorer.filterResults(false)
            }
        }

    dapScreen.initialItem: DapHistoryScreen
    {
        id:historyScreen
        dapHistoryRightPanel.onCurrentStatusSelected: {

                currentStatus = status
                logicExplorer.filterResults()
        }

        dapHistoryRightPanel.onCurrentPeriodSelected: {

                currentPeriod = period
                isCurrentRange = isRange

                logicExplorer.filterResults()
            }
    }

    onRightPanel: false

    Connections
    {
        target: dapServiceController
        onAllWalletHistoryReceived:
        {
            logicExplorer.rcvAllWalletHistory(walletHistory, false)
        }
    }

    Component.onCompleted:
    {
        logicExplorer.updateWalletHistory()

        if (!updateHistoryTimer.running)
            updateHistoryTimer.start()
    }

    Component.onDestruction:
    {
        updateHistoryTimer.stop()
    }
}
