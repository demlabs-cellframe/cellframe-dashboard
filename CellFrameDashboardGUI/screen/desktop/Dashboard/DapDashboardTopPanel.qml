import QtQuick 2.4
import Demlabs 1.0

DapDashboardTopPanelForm 
{
    Component.onCompleted:
    {
        if(dapModelWallets.count > 0)
        {
            if(dapModelWallets.get(0).name === "all wallets")
            {
                dapComboboxWallet.currentIndex = -1;
                dapModelWallets.remove(0, 1);
                dapComboboxWallet.currentIndex = 0;
            }
        }
    }
}
