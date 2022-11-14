import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets" as Widgets


Controls.DapTopPanel
{
    property alias dapNewPayment: newPaymentButton
    property alias comboBoxCurrentWallet: comboBoxCurrentWallet

    signal changeWallet(var indexWallet)

    RowLayout
    {
        anchors.fill: parent

/*        Widgets.DapBigText
        {
            id: frameTitleCreateWallet
            Layout.fillHeight: true
            Layout.leftMargin: 24
//            anchors.left: parent.left
//            anchors.leftMargin: 24
//            anchors.right: comboBoxCurrentWallet.left
//            anchors.rightMargin: 100
            height: 30
//            anchors.verticalCenter: parent.verticalCenter

            textFont: mainFont.dapFont.medium18
        }*/

        Text{
            text: "Wallet:"
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
            Layout.leftMargin: 24
        }

        Widgets.DapCustomComboBox
        {
            id: comboBoxCurrentWallet

            Layout.fillHeight: true
            Layout.topMargin: 9
            Layout.bottomMargin: 9
            Layout.leftMargin: 4
            width: 220
//            anchors.left: frameTitleCreateWallet.right
//            anchors.leftMargin: 24
    //        anchors.right: comboBoxCurrentWallet.left

            font: mainFont.dapFont.regular14
            backgroundColor: currTheme.backgroundPanel

            model: dapModelWallets

//            currentIndex: logicMainApp.currentWalletIndex

//            onModelChanged:
//            {
//                setCurrentIndex(logicMainApp.currentWalletIndex)
//            }
//            currentIndex: logicMainApp.currentWalletIndex

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
            }

            defaultText: qsTr("Wallets")
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
//            Layout.fillHeight: true
            Layout.rightMargin: 24

            textButton: "Send"
//            anchors.right: parent.right
//            anchors.rightMargin: 24

//            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
//            visible: frameTitleCreateWallet.text === "" ? false : true
    //        visible: false
        }

    }

    Connections
    {
        target: dapMainWindow
        onModelWalletsUpdated:
        {
            console.log("DapDashboardTopPanel onModelWalletsUpdated",
                        "currentWalletName", logicMainApp.currentWalletName,
                        "currentWalletIndex", logicMainApp.currentWalletIndex)

            comboBoxCurrentWallet.setCurrentIndex(logicMainApp.currentWalletIndex)
        }
    }

}
