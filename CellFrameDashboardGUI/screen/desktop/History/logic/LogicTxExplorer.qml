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
//        console.log(modulesController.currentWalletName, txExplorerModule.walletName)

        if (modulesController.currentWalletIndex >=0 && modulesController.currentWalletName !== txExplorerModule.walletName)
            txExplorerModule.setWalletName(modulesController.currentWalletName)
        txExplorerModule.updateHistory(true)
    }
}
