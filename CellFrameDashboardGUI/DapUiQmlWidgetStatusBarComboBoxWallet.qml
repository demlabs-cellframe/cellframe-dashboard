import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property DapUiQmlWidgetStatusBarComboBoxToken listToken: DapUiQmlWidgetStatusBarComboBoxToken{}
    model: dapChainWalletsModel
    textRole: "name"

    delegate: ItemDelegate {
        width: parent.width
        contentItem: DapUiQmlWidgetStatusBarContentItem {
            text: name
        }

        highlighted: parent.highlightedIndex === index
    }

    onCurrentIndexChanged: {
        listToken.model.clear();
        for(var i = 0; i < dapChainWalletsModel.get(currentIndex).count; i++)
            listToken.model.append({"tokenName": dapChainWalletsModel.get(currentIndex).tokens[++i]});
        if(listToken.model.count)
            listToken.currentIndex = 0;
    }
}
