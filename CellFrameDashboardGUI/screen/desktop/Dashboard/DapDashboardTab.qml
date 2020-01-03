import QtQuick 2.4

DapDashboardTabForm
{
    ///@detalis Path to the right pane of transaction history.
    readonly property string transactionHistoryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right pane of transaction history.
    readonly property string inputNameWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapInputNewWalletNameRightPanel.qml"
    ///@detalis Path to the right pane of transaction history.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right pane of transaction history.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"

    dapDashboardRightPanel.source: Qt.resolvedUrl(transactionHistoryWallet)
}
