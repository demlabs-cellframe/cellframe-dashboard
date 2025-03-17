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
    property string currentPeriod: qsTr("All time")
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
                modelHistory.setFilterString(text)
            }

        }

    dapScreen.initialItem: DapHistoryScreen
    {
        id:historyScreen
        dapHistoryRightPanel.onCurrentStatusSelected: {

                currentStatus = status
                modelHistory.setCurrentStatus(status)
        }

        dapHistoryRightPanel.onCurrentPeriodSelected: {

                currentPeriod = period
                isCurrentRange = isRange

                var data = [period, isRange]

                modelHistory.setCurrentPeriod(data)
            }
    }

    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

    Component.onCompleted:
    {
        modelHistory.setFilterString()
        modelHistory.setCurrentStatus(currentStatus)
        modelHistory.setLastActions(false)
        txExplorerModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        txExplorerModule.statusProcessing = false
    }
}
