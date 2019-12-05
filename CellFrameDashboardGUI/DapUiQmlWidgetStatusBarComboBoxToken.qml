import QtQuick 2.0
import QtQuick.Controls 2.0

DapUiQmlWidgetStatusBarComboBoxTokenForm {
    property Label fieldBalance: Label {}

    model: ListModel {id: tokenList}
    textRole: "tokenName"

    delegate: DapUiQmlWidgetStatusBarComboBoxDelegate {
        delegateContentText: tokenName
    }

    onCurrentIndexChanged: {
        if(currentIndex === -1)
            fieldBalance.text = 0;
        else
        {
            var money = dapChainWalletsModel.get(comboboxWallet.currentIndex).tokens[currentIndex * 3];
            fieldBalance.text = dapChainConvertor.toConvertCurrency(money);
        }
    }
}
