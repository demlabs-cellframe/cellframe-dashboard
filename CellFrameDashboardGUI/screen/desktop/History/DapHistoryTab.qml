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

    property int lastHistoryLength: 0

    property alias dapHistoryTopPanel: historyTopPanel
    property alias dapHistoryScreen: historyScreen

    id: historyTab

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

    dapHeader.initialItem: DapSearchTopPanel
        {
            id:historyTopPanel
            onFindHandler: {
                console.log(text)
                currentString = text
                txExplorerModule.setFilterString(text)
            }

        }

    dapScreen.initialItem: DapHistoryScreen
    {
        id:historyScreen
        dapHistoryRightPanel.onCurrentStatusSelected: {

                currentStatus = status
                txExplorerModule.setCurrentStatus(status)
        }

        dapHistoryRightPanel.onCurrentPeriodSelected: {

                currentPeriod = period
                isCurrentRange = isRange

                var data = [period, isRange]

                txExplorerModule.setCurrentPeriod(data)
            }
    }

    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

    Connections
    {
        target: modulesController
        function onWalletsListUpdated()
        {
            logicExplorer.historyUpdate()
        }

        function onCurrentWalletNameChanged()
        {
            logicExplorer.historyUpdate()
        }
    }

    Component.onCompleted:
    {
        txExplorerModule.statusProcessing = true
        txExplorerModule.setFilterString("")
        txExplorerModule.setCurrentStatus(currentStatus)
        txExplorerModule.setLastActions(false)
        logicExplorer.historyUpdate()
    }

    Component.onDestruction:
    {
        txExplorerModule.statusProcessing = false
    }
}
