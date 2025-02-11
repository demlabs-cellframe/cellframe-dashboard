import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "../controls" as Controls
import "qrc:/widgets"
import "../../"

Controls.DapTopPanel
{
    anchors.leftMargin: 4
//    radius: currTheme.frameRadius
//    color: currTheme.backgroundPanel

    ListModel{id: stockModelTokens}

    Controls.DapLoadingTopPanel
    {
    }

    RowLayout
    {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Label
        {
            id: backToStock
            Layout.rightMargin: 40
            font: mainFont.dapFont.regular16
            color: currTheme.white
            text: " <  " + qsTr("DEX")
            visible: false

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    stockScreen.changeMainPage(
                                "parts/StockHome.qml")
                    backToStock.visible = false
                }
            }
        }

        // Static text "Wallet"
        Label
        {
            id: textHeaderWallet
            text: qsTr("Wallet: ")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
            Layout.alignment: Qt.AlignVCenter
        }
        
        DapWalletComboBox
        {
            id: comboBoxCurrentWallet

            Layout.fillHeight: true
            Layout.topMargin: 9
            Layout.bottomMargin: 9
            Layout.leftMargin: 2
            width: 220
            displayText: walletModule.currentWalletName
            font: mainFont.dapFont.regular14

            model: walletModelList

            enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
            disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"

            Component.onCompleted:
            {
                console.log("DapDashboardTopPanel onCompleted",
                            "logicMainApp.currentWalletIndex", walletModule.currentWalletIndex)
                setCurrentIndex(walletModule.currentWalletIndex)
            }

            defaultText: qsTr("Wallets")
        }
//         DapBigText
//         {
//             id: textNameWallet
//             height: 42
// //            text: dapModelWallets.get(logicMainApp.currentWalletIndex).name
//             Layout.alignment: Qt.AlignVCenter
//             Layout.maximumWidth: 220
//             Layout.minimumWidth: 220
// //            Layout.leftMargin: 4
//             Layout.leftMargin: 19
//             fullText: walletController.currentWalletName

//             textFont: mainFont.dapFont.regular14
//         }

//        DapCustomComboBox{
//            id: textNameWallet
////            width: 95
//            Layout.minimumWidth: 220
//            Layout.maximumWidth: 220
//            font: mainFont.dapFont.regular14

//            currentIndex: logicMainApp.currentWalletIndex
//            model: dapModelWallets

//            backgroundColorShow: currTheme.backgroundMainScreen

//            onCurrentIndexChanged: updateBalance()
//        }

        // Static token text "Token: "
        Label
        {
            id: headerWalletToken
            Layout.leftMargin: 32
            text: qsTr("Token: ")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
        }

        DapCustomComboBox{
            id: tokenComboBox
            Layout.minimumWidth: 160
            Layout.maximumWidth: 160
            Layout.leftMargin: 4
            font: mainFont.dapFont.regular14
            model: dexTokenModel
            
            mainTextRole: "tokenName"
            onModelChanged:
            {
                if (tokenComboBox.currentIndex < 0)
                {
                    dexModule.setCurrentToken(defaultText)
                }
                else
                {
                    dexModule.setCurrentToken(getModelData(popupListView.currentIndex, mainTextRole))
                }
            }

            onCurrantDisplayTextChanged:
            {
                dexModule.setCurrentToken(text)
            }

            onCurrentIndexChanged: 
            {
                dexModule.setCurrentToken(displayText)
                updateBalance()
            }

            Connections
            {
                target: dexTokenModel
                function onListTokenChanged()
                {
                    var cur_token = dexTokenModel.getFirstToken()
                    dexModule.setCurrentToken(cur_token)
                    tokenComboBox.displayText = cur_token
                }
            }
        }

        Item{
            Layout.minimumWidth: 160
            Layout.maximumWidth: 160
            Layout.leftMargin: 4
            visible: !tokenComboBox.visible
        }

        // Static wallet balance text "Wallet balance"
        Label
        {
            id: headerWalletBalance
            Layout.leftMargin: 32
            text: qsTr("Token balance: ")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
            Layout.alignment: Qt.AlignVCenter
        }

        // Dynamic wallet balance text

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 19
            Layout.alignment: Qt.AlignLeft

            DapBigText
            {
                id: textWalletBalance
                anchors.fill: parent
                textFont: mainFont.dapFont.regular16
                fullText: dexModule.balance
            }
        }
    }

    Connections{
        target: stockTab
        function onTokenPairChanged()
        {
            updatePair()
        }
    }

    function updatePair()
    {
        var modelWallet = dapModelWallets.get(logicMainApp.currentWalletIndex)
        stockModelTokens.clear()

        updateBalance()

        if(stockModelTokens.count)
        {
            tokenComboBox.visible = true
            textWalletBalance.visible = true
        }
        else
        {
            tokenComboBox.visible = false
            textWalletBalance.visible = false
        }
    }

    function updateBalance()
    {
        print("updateBalance",
              "tokenComboBox.count", tokenComboBox.count)

        if(tokenComboBox.count)
        {
            // textWalletBalance.fullText = tokenComboBox.getModelData(tokenComboBox.currentIndex,"coins")
            logicStock.selectedTokenNameWallet = tokenComboBox.getModelData(tokenComboBox.currentIndex,"name")
            logicStock.selectedTokenBalanceWallet = textWalletBalance.fullText
        }

        if(tokenComboBox.count === 2)
        {
            var unselectedIndex = tokenComboBox.currentIndex === 1 ? 0 : 1

            logicStock.unselectedTokenNameWallet = tokenComboBox.getModelData(unselectedIndex,"name")
            logicStock.unselectedTokenBalanceWallet = tokenComboBox.getModelData(unselectedIndex,"coins")
        }
        else if(tokenComboBox.count)
        {
            var name = logicStock.selectedTokenNameWallet
                    === tokenPairsWorker.tokenBuy ? tokenPairsWorker.tokenSell:
                                                  tokenPairsWorker.tokenBuy
            logicStock.unselectedTokenNameWallet = name
            logicStock.unselectedTokenBalanceWallet = 0
        }
        else
        {
            logicStock.selectedTokenNameWallet = ""
            logicStock.selectedTokenBalanceWallet = ""
            logicStock.unselectedTokenNameWallet = 0
            logicStock.unselectedTokenBalanceWallet = 0
        }
    }

    function setBackToStockVisible(visible)
    {
        backToStock.visible = visible
    }

    Connections
    {
        target: walletModule

        function onCurrentWalletChanged()
        {
            comboBoxCurrentWallet.displayText = walletModule.currentWalletName
        }

        function onWalletsModelChanged()
        {
            comboBoxCurrentWallet.displayText = walletModule.currentWalletName
        }

        function onListWalletChanged()
        {
            if(walletModule.currentWalletIndex >= 0)
            {
                 comboBoxCurrentWallet.displayText = walletModule.currentWalletName
            }
        }
    }
    
    Component.onCompleted:
    {
        comboBoxCurrentWallet.displayText = walletModule.currentWalletName
    }
}
