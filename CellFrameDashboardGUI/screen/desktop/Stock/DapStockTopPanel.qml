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
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

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
            color: currTheme.textColor
            Layout.alignment: Qt.AlignVCenter
        }
        Label
        {
            id: textNameWallet
            text: dapModelWallets.get(logicMainApp.currentIndex).name
            Layout.alignment: Qt.AlignVCenter

            font: mainFont.dapFont.regular16
            color: currTheme.textColor
        }

        // Static token text "Token: "
        Label
        {
            id: headerWalletToken
            Layout.leftMargin: 40
            text: "Token: "
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
        }

        DapCustomComboBox{
            id: tokenComboBox
//            width: 95
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
            font: mainFont.dapFont.regular16

            backgroundColor: currTheme.backgroundMainScreen

            Component.onCompleted: {
                updatePair()
            }

            onCurrentIndexChanged: updateBalance()
        }

        // Static wallet balance text "Wallet balance"
        Label
        {
            id: headerWalletBalance
            Layout.leftMargin: 40
            text: qsTr("Token balance: ")
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Dynamic wallet balance text
        Text
        {
            id: textWalletBalance

            Layout.fillWidth: true

            font: mainFont.dapFont.regular16
            color: currTheme.textColor

            elide: Text.ElideMiddle

            ToolTip
            {
                id:toolTip
                visible: area.containsMouse ?  parent.implicitWidth > parent.width ? true : false : false
                text: parent.text
                scale: mainWindow.scale

                contentItem: Text {
                        text: toolTip.text
                        font: mainFont.dapFont.regular14
                        color: currTheme.textColor
                    }
                background: Rectangle{color:currTheme.backgroundPanel}
            }
            MouseArea
            {
                id:area
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    Connections{
        target: stockTab
        onTokenPairChanged:
        {
            updatePair()
        }
    }

    function updatePair()
    {
        var modelWallet = dapModelWallets.get(logicMainApp.currentIndex)
        stockModelTokens.clear()

//        print("updatePair",
//              "logicMainApp.token1Name", logicMainApp.token1Name,
//              "logicMainApp.token2Name", logicMainApp.token2Name,
//              "logicMainApp.tokenNetwork", logicMainApp.tokenNetwork)

        for(var i = 0; i < modelWallet.networks.count; i++)
        {
            if(logicMainApp.tokenNetwork === modelWallet.networks.get(i).name)
            {
                for(var k = 0; k < modelWallet.networks.get(i).tokens.count; k++)
                {
                    if(modelWallet.networks.get(i).tokens.get(k).name
                            === logicMainApp.token1Name ||
                       modelWallet.networks.get(i).tokens.get(k).name
                            === logicMainApp.token2Name)
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
            textWalletBalance.text = tokenComboBox.getModelData(tokenComboBox.currentIndex,"balance_without_zeros")
            logicStock.selectedTokenNameWallet = tokenComboBox.getModelData(tokenComboBox.currentIndex,"name")
            logicStock.selectedTokenBalanceWallet = textWalletBalance.text
        }

        if(tokenComboBox.count === 2)
        {
            var unselectedIndex = tokenComboBox.currentIndex === 1 ? 0 : 1

            logicStock.unselectedTokenNameWallet = tokenComboBox.getModelData(unselectedIndex,"name")
            logicStock.unselectedTokenBalanceWallet = tokenComboBox.getModelData(unselectedIndex,"balance_without_zeros")
        }
        else if(tokenComboBox.count)
        {
            var name = logicStock.selectedTokenNameWallet
                    === logicMainApp.token1Name ? logicMainApp.token2Name:
                                                  logicMainApp.token1Name
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
