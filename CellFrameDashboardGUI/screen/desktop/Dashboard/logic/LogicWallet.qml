import QtQuick 2.12
import QtQml 2.12

QtObject {

    property bool restoreWalletMode: false
    property string walletType: "Standart"
    property string walletRecoveryType: "Words"
    property string walletStatus: ""

    function initNetworks()
    {
        networksModel.clear()

        var tempNetworks = dapModelWallets.
            get(walletModule.getCurrentIndex()).networks

        for (var i = 0; i < tempNetworks.count; ++i)
        {
            networksModel.append(
                        { "tokens" : []})

            for (var j = 0; j < tempNetworks.get(i).tokens.count; ++j)
            {
                networksModel.get(i).tokens.append(
                    { "name" : tempNetworks.get(i).tokens.get(j).name,
                      "datoshi": tempNetworks.get(i).tokens.get(j).datoshi,
                      "coins": tempNetworks.get(i).tokens.get(j).coins})
            }
        }
    }
}
