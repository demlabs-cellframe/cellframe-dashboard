import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "../controls" as Controls
import "qrc:/widgets"

Controls.DapTopPanel
{
    anchors.leftMargin: 4
//    radius: currTheme.radiusRectangle
//    color: currTheme.backgroundPanel

    ListModel{id: stockModelTokens}

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
            color: currTheme.textColor
            text: qsTr(" <  DEX")
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
            color: currTheme.textColorGray
            Layout.alignment: Qt.AlignVCenter
        }
        DapBigText
        {
            id: textNameWallet
            height: 42
//            text: dapModelWallets.get(logicMainApp.currentWalletIndex).name
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 220
            Layout.minimumWidth: 220
//            Layout.leftMargin: 4
            Layout.leftMargin: 19
            fullText: dapModelWallets.get(logicMainApp.currentWalletIndex).name

            textFont: mainFont.dapFont.regular14
        }

//        DapCustomComboBox{
//            id: textNameWallet
////            width: 95
//            Layout.minimumWidth: 220
//            Layout.maximumWidth: 220
//            font: mainFont.dapFont.regular14

//            currentIndex: logicMainApp.currentWalletIndex
//            model: dapModelWallets

//            backgroundColor: currTheme.backgroundMainScreen

//            onCurrentIndexChanged: updateBalance()
//        }

        // Static token text "Token: "
        Label
        {
            id: headerWalletToken
            Layout.leftMargin: 32
            text: "Token: "
            font: mainFont.dapFont.regular14
            color: currTheme.textColorGray
        }

        DapCustomComboBox{
            id: tokenComboBox
//            width: 95
            Layout.minimumWidth: 160
            Layout.maximumWidth: 160
            Layout.leftMargin: 4
            font: mainFont.dapFont.regular14

            backgroundColor: currTheme.backgroundMainScreen

            Component.onCompleted: {
                updatePair()
            }

            onCurrentIndexChanged: updateBalance()
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
            color: currTheme.textColorGray
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
            }
        }
//        Text
//        {
//            id: textWalletBalance

//            Layout.fillWidth: true

//            font: mainFont.dapFont.regular16
//            color: currTheme.textColor

//            elide: Text.ElideMiddle

//            ToolTip
//            {
//                id:toolTip
//                visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
//                text: parent.text
//                scale: mainWindow.scale

//                contentItem: Text {
//                        text: toolTip.text
//                        font: mainFont.dapFont.regular14
//                        color: currTheme.textColor
//                    }
//                background: Rectangle{color:currTheme.backgroundPanel}
//            }
//            MouseArea
//            {
//                id:area
//                anchors.fill: parent
//                hoverEnabled: true
//            }
//        }
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

//        print("updatePair",
//              "tokenPairsWorker.tokenBuy", tokenPairsWorker.tokenBuy,
//              "tokenPairsWorker.tokenSell", tokenPairsWorker.tokenSell,
//              "tokenPairsWorker.tokenNetwork", tokenPairsWorker.tokenNetwork)

        for(var i = 0; i < modelWallet.networks.count; i++)
        {
            if(tokenPairsWorker.tokenNetwork === modelWallet.networks.get(i).name)
            {
                for(var k = 0; k < modelWallet.networks.get(i).tokens.count; k++)
                {
                    if(modelWallet.networks.get(i).tokens.get(k).name
                            === tokenPairsWorker.tokenBuy ||
                       modelWallet.networks.get(i).tokens.get(k).name
                            === tokenPairsWorker.tokenSell)
                    {
                        stockModelTokens.append(modelWallet.networks.get(i).tokens.get(k))
                    }
                }

                if(stockModelTokens.count)
                {
                    tokenComboBox.model =  stockModelTokens
                    tokenComboBox.currentIndex = 0
                }

                break
            }
        }

//        print("updatePair",
//              "stockModelTokens.count", stockModelTokens.count)
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
            textWalletBalance.fullText = tokenComboBox.getModelData(tokenComboBox.currentIndex,"coins")
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
}
