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

    signal changeWallet(var indexWallet)

    RowLayout
    {
        id: layout
        anchors.fill: parent

        Text{
            text: qsTr("Wallet:")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
            Layout.leftMargin: 21
//            visible: comboBoxCurrentWallet.visible
        }

        Widgets.DapCustomComboBox
        {
            id: comboBoxCurrentWallet

            Layout.fillHeight: true
            Layout.topMargin: 9
            Layout.bottomMargin: 9
            Layout.leftMargin: 4
            width: 220

            font: mainFont.dapFont.regular14

            model: dapModelWallets

            enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
            disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"

            Component.onCompleted:
            {
                console.log("DapDashboardTopPanel onCompleted",
                            "logicMainApp.currentWalletIndex", logicMainApp.currentWalletIndex)
                setCurrentIndex(logicMainApp.currentWalletIndex)
            }

            onItemSelected:
            {
                logicMainApp.currentWalletName = currentText
                logicMainApp.currentWalletIndex = currentIndex

                console.log("DapDashboardTopPanel onItemSelected",
                            "currentWalletName", logicMainApp.currentWalletName,
                            "currentWalletIndex", logicMainApp.currentWalletIndex)

                logicWallet.updateWalletModel()
                changeWallet(logicMainApp.currentWalletIndex)

                historyWorker.setWalletName(
                    dapModelWallets.get(logicMainApp.currentWalletIndex).name)
            }

            defaultText: qsTr("Wallets")
        }

        Widgets.DapButton
        {
            Layout.leftMargin: 24

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

            textButton: qsTr("Send")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked: {
                walletInfo.name = dapModelWallets.get(logicMainApp.currentWalletIndex).name
                dapRightPanel.pop()
                navigator.newPayment()
            }
        }

    }

    Connections
    {
        target: dapMainWindow
        function onModelWalletsUpdated()
        {
            console.log("DapDashboardTopPanel onModelWalletsUpdated",
                        "currentWalletName", logicMainApp.currentWalletName,
                        "currentWalletIndex", logicMainApp.currentWalletIndex)

            comboBoxCurrentWallet.setCurrentIndex(logicMainApp.currentWalletIndex)
        }
    }
}
