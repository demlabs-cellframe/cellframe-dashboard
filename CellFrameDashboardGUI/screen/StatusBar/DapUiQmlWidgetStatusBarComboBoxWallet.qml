import QtQuick 2.0
import QtQuick.Controls 2.0
import "../"

DapUiQmlWidgetStatusBarComboBoxWalletForm {
    property Label fieldBalance: Label {}
    model: dapWalletModel.wallets

    delegate: DapUiQmlWidgetStatusBarComboBoxDelegate {
        delegateContentText: modelData
    }

    onCurrentTextChanged: {
        dapWalletFilterModel.setWalletFilter(currentText);

    }
}
