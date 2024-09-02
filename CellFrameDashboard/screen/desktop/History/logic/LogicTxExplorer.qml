import QtQuick 2.12
import QtQml 2.12

QtObject {

    property int selectTxIndex: -1

    property var commandResult

    function initDetailsModel(model)
    {
        detailsModel.clear()
        detailsModel.append(model)
    }

    function historyUpdate()
    {
//        console.log(modulesController.currentWalletName, txExplorerModule.walletName)

        // if (walletModule.currentWalletIndex >=0 && modulesController.currentWalletName !== txExplorerModule.walletName)
        //     txExplorerModule.setWalletName(modulesController.currentWalletName)
        // txExplorerModule.updateHistory(true)
    }
}
