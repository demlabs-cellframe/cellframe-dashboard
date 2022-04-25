import QtQuick 2.4
import "qrc:/"
import "../../"
import "../SettingsWallet.js" as SettingsWallet

DapAbstractTab
{
    property var exchangeTokenModel: dapModelWallets.get(SettingsWallet.currentIndex).networks.get(dapServiceController.IndexCurrentNetwork).tokens

    id: exchangeTab
    color: currTheme.backgroundMainScreen

    dapTopPanel: DapExchangeTopPanel { }
    dapScreen: DapExchangeScreen { }
    dapRightPanel: DapExchangeRightPanel { }

}
