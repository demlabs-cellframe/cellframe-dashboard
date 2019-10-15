import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property DapUiQmlWidgetStatusBarComboBoxToken listToken: DapUiQmlWidgetStatusBarComboBoxToken{}
    model: dapChainWalletsModel
    textRole: "name"

    delegate: ItemDelegate {
        width: parent.width
        contentItem: DapUiQmlWidgetStatusBarContentItem {
            text: name
            color: hovered ? "#FFFFFF" : "#332F49"
        }

        background: Rectangle {
            height: 32 * pt
            color: hovered ? "#B0B2B5" : "#FFFFFF"
        }

        highlighted: parent.highlightedIndex === index

    }

    onCurrentIndexChanged: {
        listToken.model.clear();
        for(var i = 0; i < dapChainWalletsModel.get(currentIndex).count; i++)
        {
            console.debug(dapChainWalletsModel.get(currentIndex).tokens);
            listToken.model.append({"tokenName": dapChainWalletsModel.get(currentIndex).tokens[++i]});
        }
        if(listToken.model.count)
            listToken.currentIndex = 0;
    }
}
