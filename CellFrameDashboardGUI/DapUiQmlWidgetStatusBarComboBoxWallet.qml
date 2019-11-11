import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQml 2.13


DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property Label fieldBalance: Label {}
    model: dapChainWalletsModel
    textRole: "name"

    delegate: DapUiQmlWidgetStatusBarComboBoxDelegate {
        delegateContentText: name
    }

    onCurrentIndexChanged: {
        var money = 0.0
        for(var i = 0; i < dapChainWalletsModel.get(currentIndex).count; i += 3)
            money += parseFloat(dapChainWalletsModel.get(currentIndex).tokens[i]);
        fieldBalance.text = money;
    }
}
