import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQml 2.13
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
