import QtQuick 2.4
import Demlabs 1.0

DapDashboardTopPanelForm 
{
    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            if(wallet[0] === true)
                updateModel(wallet)
            else
                console.log(wallet[1])
        }
    }
}
