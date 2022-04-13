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

    property alias dapModelLastActions: modelLastActions

    property int lastHistoryLength: 0

    ListModel{id: modelLastActions}
    ListModel{id: newModelLastActions}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    LogicTxExplorer{id: logicExplorer}

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 * pt
            width: parent.width
            color: currTheme.backgroundMainScreen

            property date payDate: new Date(Date.parse(section))

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                anchors.rightMargin: 16 * pt
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.textColor
                text: logicExplorer.getDateString(payDate)
                font: mainFont.dapFont.medium12
            }
        }
    }

    Connections
    {
        target: dapServiceController
        onAllWalletHistoryReceived:
        {
            logicExplorer.rcvAllWalletHistory(walletHistory, true)
        }

    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            lastHistoryLength = 0

            logicExplorer.updateWalletHistory(true)
        }
    }

    Timer {
        id: updateTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            logicExplorer.updateWalletHistory(true)
        }
    }

    Component.onCompleted:
    {
        lastHistoryLength = 0
        logicExplorer.updateWalletHistory(true)

        if (!updateTimer.running)
            updateTimer.start()
    }

    Component.onDestruction:
    {
        updateTimer.stop()
    }
}
