import QtQuick 2.9
import QtQml 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"
import "../../History/logic"

DapLastActionsRightPanelForm
{
    property int lastHistoryLength: 0
//    ListModel{id: modelLastActions}
    ListModel{id: newModelLastActions}
    ListModel{id: temporaryModel}
    ListModel{id: previousModel}

    Component
    {
        id: delegateSection
        Rectangle
        {
            height: 30 
            width: parent.width
            color: currTheme.mainBackground

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 
                anchors.rightMargin: 16 
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: currTheme.white
                text: dateWorker.getDateString(section)
                font: mainFont.dapFont.medium12
            }
        }
    }

    Connections
    {
        target: dashboardTab
        function onWalletsUpdated()
        {
            lastHistoryLength = 0

            if (modulesController.currentWalletIndex >=0 &&
                modulesController.currentWalletIndex < dapModelWallets.count)
                txExplorerModule.setWalletName(modulesController.currentWalletName)

            txExplorerModule.updateHistory(true)
        }
    }

    Component.onCompleted:
    {
        txExplorerModule.setLastActions(true)
        if (modulesController.currentWalletIndex >=0 &&
            modulesController.currentWalletIndex < dapModelWallets.count)
            txExplorerModule.setWalletName(modulesController.currentWalletName)
        lastHistoryLength = 0
        txExplorerModule.updateHistory(true)
    }

}
