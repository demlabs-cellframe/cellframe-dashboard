import QtQuick 2.9
import QtQml 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../History/logic"

DapLastActionsRightPanelForm
{
    ////@ Variables to calculate Today, Yesterdat etc.
    property date today: new Date()
    property date yesterday: new Date(new Date().setDate(new Date().getDate()-1))

    property date lastDate: new Date(0)
    property date prevDate: new Date(0)

//    property alias dapModelLastActions: modelLastActions

    property int lastHistoryLength: 0

//    ListModel{id: modelLastActions}
    ListModel{id: newModelLastActions}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    LogicTxExplorer{id: logicExplorer}

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 
            width: parent.width
            color: currTheme.mainBackground

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 
                anchors.rightMargin: 16 
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: logicExplorer.getDateString(payDate)
                font: mainFont.dapFont.medium12
            }
        }
    }

    Connections{
        target: dashboardTopPanel
        function onChangeWallet() {
//            lastHistoryLength = 0
//            temporaryModel.clear()
//            modelLastActions.clear()
            logicExplorer.updateWalletHistory(true, 1, true)
        }
    }

    Connections
    {
        target: dapMainWindow
        function onModelWalletsUpdated()
        {
            lastHistoryLength = 0

            logicExplorer.updateWalletHistory(true, 1,true)

            if (logicMainApp.currentWalletIndex >=0 &&
                logicMainApp.currentWalletIndex < dapModelWallets.count)
                historyWorker.setWalletName(
                    dapModelWallets.get(logicMainApp.currentWalletIndex).name)
        }
    }

    Timer {
        id: updateLastActionTimer
        interval: logicMainApp.autoUpdateHistoryInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("LAST ACTIONS TICK")
            logicExplorer.updateWalletHistory(true, 0, true)
        }
    }

    Component.onCompleted:
    {
        historyWorker.setLastActions(true)
        if (logicMainApp.currentWalletIndex >=0 &&
            logicMainApp.currentWalletIndex < dapModelWallets.count)
            historyWorker.setWalletName(
                dapModelWallets.get(logicMainApp.currentWalletIndex).name)
        lastHistoryLength = 0
        logicExplorer.updateWalletHistory(true, 1, true)

        if (!updateLastActionTimer.running)
            updateLastActionTimer.start()
    }

    Component.onDestruction:
    {
        updateLastActionTimer.stop()
    }
}
