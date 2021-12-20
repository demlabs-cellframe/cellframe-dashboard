import QtQuick 2.4
import "../../SettingsWallet.js" as SettingsWallet

DapNewPaymentDoneRightPanelForm
{
    dapButtonSend.onClicked:
    {
        console.log("dapButtonSend.onClicked")

//        dapServiceController.requestToService("DapGetWalletsInfoCommand");
        dapServiceController.requestWalletInfo(
                    dapModelWallets.get(SettingsWallet.currentIndex).name);

        nextActivated("transaction done")
    }

    dapButtonClose.onClicked:
    {
        previousActivated(lastActionsWallet)
    }
}
