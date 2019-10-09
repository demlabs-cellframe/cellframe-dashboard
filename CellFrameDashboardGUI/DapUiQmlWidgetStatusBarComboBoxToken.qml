import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

DapUiQmlWidgetStatusBarComboBoxTokenForm {
    property Label fieldBalance: Label {}

    model: ListModel {id: tokenList}
    textRole: "tokenName"

    delegate: ItemDelegate {
        width: parent.width
        contentItem: DapUiQmlWidgetStatusBarContentItem {
            text: tokenName
        }

        highlighted: parent.highlightedIndex === index
    }

    onCurrentIndexChanged: {
        if(currentIndex === -1)
            fieldBalance.text = 0;
        else
        {
            var money = dapChainWalletsModel.get(comboboxWallet.currentIndex).tokens[currentIndex * 2];
            fieldBalance.text = dapChainConvertor.toConvertCurrency(money);
        }
    }
}
