import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"

DapPage
{
    property var exchangeTokenModel: dapModelWallets.get(logicMainApp.currentIndex).networks.get(dapServiceController.IndexCurrentNetwork).tokens
//    id: exchangeTab
//    color: currTheme.backgroundMainScreen

//    dapTopPanel: DapExchangeTopPanel { }
//    dapScreen: DapExchangeScreen { }
//    dapRightPanel: DapExchangeRightPanel { }

    dapHeader.initialItem: DapExchangeTopPanel
    {
        id: exchangeTopPanel
    }

    dapScreen.initialItem: DapExchangeScreen
    {
        id: exchangeScreen
    }

    onRightPanel: false
}
