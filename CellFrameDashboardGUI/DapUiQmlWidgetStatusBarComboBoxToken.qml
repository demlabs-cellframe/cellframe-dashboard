import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

DapComboBox{
    property Label fieldBalance: Label {}

    model: ListModel {id: tokenList}
    textRole: "tokenName"

    delegate: DapComboBoxDelegate {
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
