import QtQuick 2.12
import QtQml 2.12

QtObject {

    property int selectTxIndex: -1

    property var commandResult

    function initDetailsModel()
    {
        detailsModel.clear()
        detailsModel.append(modelHistory.get(selectTxIndex))
    }

    function historyUpdate()
    {
        if (modulesController.currentWalletIndex >=0)
            txExplorerModule.setWalletName(modulesController.currentWalletName)
        txExplorerModule.updateHistory(true)
    }
}
