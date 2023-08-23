import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets" as Widgets


Controls.DapTopPanel
{
    property alias layout: layout

    signal changeWalletIndex()

    RowLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 0

        Text{
            text: qsTr("Wallet:")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
            Layout.leftMargin: 21
        }

        DapWalletComboBox
        {
            id: comboBoxCurrentWallet

            Layout.fillHeight: true
            Layout.topMargin: 9
            Layout.bottomMargin: 9
            Layout.leftMargin: 4
            width: 220

            font: mainFont.dapFont.regular14

            model: walletListModel

            enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
            disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"

            Component.onCompleted:
            {
                console.log("DapDashboardTopPanel onCompleted",
                            "logicMainApp.currentWalletIndex", modulesController.currentWalletIndex)
                setCurrentIndex(modulesController.currentWalletIndex)
            }

            onItemSelected:
            {
                modulesController.currentWalletIndex = currentIndex

                console.log("DapDashboardTopPanel onItemSelected",
                            "currentWalletName", modulesController.currentWalletName,
                            "currentWalletIndex", modulesController.currentWalletIndex,)
                changeWalletIndex()

            }

            defaultText: qsTr("Wallets")
        }

        Rectangle{
            id: buttonActivate
            Layout.leftMargin: 2
            width: 32
            height: 32
            radius: 4
            color: area.containsMouse ? currTheme.rowHover : currTheme.secondaryBackground

            visible: !dapModelWallets.count ? false : true
            Image{
                anchors.centerIn: parent
                source:
                {
                    console.log(" WALLET STATUS = " + logicWallet.walletStatus)
                    if(logicWallet.walletStatus === "")
                    {
                        console.log(" WALLET STATUS IN = " + logicWallet.walletStatus)
                        return "qrc:/Resources/BlackTheme/icons/other/icon_activate_pass.svg"
                    }
                    console.log(" WALLET STATUS OUT = " + logicWallet.walletStatus)
                    return logicWallet.walletStatus === "non-Active" ? "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                                                                                         : "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
                }
                mipmap: true
            }


            MouseArea{
                id: area
                hoverEnabled: true
                anchors.fill: parent

                onClicked: {
                    if(logicWallet.walletStatus === "")
                    {
                        tryCreatePasswordWalletPopup.show(dapModelWallets.get(modulesController.currentWalletIndex).name, createPasswordWalletPopup, false)
                    }
                    else if(logicWallet.walletStatus === "non-Active")
                    {
                        walletActivatePopup.show(dapModelWallets.get(modulesController.currentWalletIndex).name, false)
                    }
                    else
                    {
                        walletDeactivatePopup.show(dapModelWallets.get(modulesController.currentWalletIndex).name)
                    }
                }
            }
        }

        Widgets.DapButton
        {
            Layout.leftMargin: 29

            textButton: qsTr("Import wallet")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            selected: false
            onClicked: navigator.restoreWalletFunc()
        }

        Widgets.DapButton
        {
            Layout.leftMargin: 16

            textButton: qsTr("Create new wallet")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            selected: false
            onClicked: navigator.createWallet()
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Payment button
        Widgets.DapButton
        {
            id: newPaymentButton
            Layout.rightMargin: 24
            enabled: logicWallet.walletStatus !== "non-Active"

            textButton: qsTr("Send")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked: {
                walletInfo.name = modulesController.currentWalletName
                dapRightPanel.pop()
                navigator.newPayment()
            }
        }
    }

    Connections
    {
        target: dashboardTab
        function onWalletsUpdated()
        {
            console.log("DapDashboardTopPanel onModelWalletsUpdated",
                        "currentWalletName", modulesController.currentWalletName,
                        "currentWalletIndex", modulesController.currentWalletIndex)

            if(modulesController.currentWalletIndex >= 0)
            {
                comboBoxCurrentWallet.setCurrentIndex(modulesController.currentWalletIndex)
                comboBoxCurrentWallet.displayText = modulesController.currentWalletName
            }
        }
    }
}
