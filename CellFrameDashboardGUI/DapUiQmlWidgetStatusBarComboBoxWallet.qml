import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property DapUiQmlWidgetStatusBarComboBoxToken listToken: DapUiQmlWidgetStatusBarComboBoxToken{}
    model: dapChainWalletsModel
    textRole: "name"

    delegate: DapUiQmlWidgetStatusBarComboBoxDelegate {
        delegateContentText: name
    }

    onCurrentIndexChanged: {
        listToken.model.clear();
        for(var i = 2; i < dapChainWalletsModel.get(currentIndex).count; i += 3)
            listToken.model.append({"tokenName": dapChainWalletsModel.get(currentIndex).tokens[i]});
        if(listToken.model.count)
            listToken.currentIndex = 0;
    }
}
