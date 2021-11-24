import QtQuick 2.4

DapCreateWalletForm
{
    dapNextRightPanel: recoveryWallet
    dapPreviousRightPanel: ""

    property string dapSignatureTypeWallet

    Component.onCompleted:
    {
        if (currentTab === dashboardScreenPath)
          dapPreviousRightPanel = lastActionsWallet
        if (currentTab === settingsScreenPath)
          dapPreviousRightPanel = emptyRightPanel
    }

    dapComboBoxSignatureTypeWallet.onCurrentIndexChanged:
    {
        dapSignatureTypeWallet = dapSignatureTypeWalletModel.get(dapComboBoxSignatureTypeWallet.currentIndex).sign
    }

    dapComboBoxOperation.onCurrentIndexChanged:
    {
        walletOperation = operationModel.get(dapComboBoxOperation.currentIndex).operation
    }

    dapButtonNext.onClicked:
    {
        walletOperation = operationModel.get(dapComboBoxOperation.currentIndex).operation
        if (dapTextInputNameWallet.text === "")
        {
            dapWalletNameWarning.text =
                qsTr("Enter the wallet name using Latin letters, dotes, dashes and / or numbers.")
            console.warn("Empty wallet name")
        }
        else
        {
            dapWalletNameWarning.text = ""

            walletInfo.name = dapTextInputNameWallet.text
            walletInfo.signature_type = dapSignatureTypeWallet

            if (walletRecoveryType !== "Nothing")
            {
                print("walletRecoveryType", walletRecoveryType)

                dapNextRightPanel = recoveryWallet
                nextActivated("recoveryWallet");
            }
            else
            {
                dapNextRightPanel = doneWallet

                console.log("Create new wallet " + walletInfo.name);
                console.log(walletInfo.signature_type);
                dapServiceController.requestToService("DapAddWalletCommand",
                       walletInfo.name,
                       walletInfo.signature_type)
            }

        }

    }

    dapButtonClose.onClicked:
    {
        dapWalletNameWarning.text = ""
        if (currentTab === dashboardScreenPath)
            previousActivated(lastActionsWallet)
        if (currentTab === settingsScreenPath)
            previousActivated(emptyRightPanel)
    }

    Connections
    {
        target: dapServiceController
        onWalletCreated:
        {
            nextActivated("doneWallet");
        }
    }
}
