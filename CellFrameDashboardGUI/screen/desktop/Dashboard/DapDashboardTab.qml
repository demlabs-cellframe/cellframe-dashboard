import QtQuick 2.4

DapDashboardTabForm
{
    ///@detalis Path to the right pane of transaction history.
    readonly property string transactionHistoryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapTransactionHistoryRightPanel.qml"
    ///@detalis Path to the right pane of name wallet.
    readonly property string inputNameWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapInputNewWalletNameRightPanel.qml"
    ///@detalis Path to the right pane of revory wallet.
    readonly property string recoveryWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapRecoveryWalletRightPanel.qml"
    ///@detalis Path to the right pane of done wallet.
    readonly property string doneWallet: "qrc:/screen/" + device + "/Dashboard/RightPanel/DapDoneWalletRightPanel.qml"

    dapDashboardRightPanel.source: Qt.resolvedUrl(transactionHistoryWallet)
    
    dapDashboardTopPanel.dapAddWalletButton.onClicked: 
    {
        if(dapDashboardRightPanel.source != Qt.resolvedUrl(inputNameWallet))
            dapDashboardRightPanel.setSource(Qt.resolvedUrl(inputNameWallet))
    }
}
