import QtQuick 2.4

DapDashboardTabForm
{
    ///@detalis Path to the right panel of transaction history.
    readonly property string transactionHistoryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right panel of input name wallet.
    readonly property string inputNameWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapInputNewWalletNameRightPanel.qml"
    ///@detalis Path to the right panel of recovery.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right panel of done.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"
    ///@detalis Path to the right panel of last actions.
    readonly property string lastActionsWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapLastActionsRightPanel.qml"

    dapDashboardRightPanel.source: Qt.resolvedUrl(lastActionsWallet)

    dapDashboardTopPanel.dapComboboxWallet.onCurrentIndexChanged:
    {
        dapDashboardScreen.dapListViewWallets.model = modelWallets.get(dapDashboardTopPanel.dapComboboxWallet.currentIndex).networks
    }

    ListModel
    {
        id: modelWallets
    }
}
