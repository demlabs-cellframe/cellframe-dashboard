import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

Item{
//    property var tokenData: selectedToken.get(0)
    property bool isSell: false

    property string currentOrder: "Limit"

    Component.onCompleted:
    {
        updateWalletInfo()
        updatePriceAndName()
    }

    onIsSellChanged:
    {
        updateWalletInfo()
        updatePriceAndName()
    }

    Connections
    {
        target: dapMainWindow
        onChangeCurrentWallet:
        {
            console.log("CreateOrderItem", "onChangeCurrentWallet")

            updateWalletInfo()
            updatePriceAndName()
        }
    }

    Connections
    {
        target: tokenPanel
        onTokenPairChanged:
        {
            console.log("CreateOrderItem", "onTokenPairChanged")

            updateWalletInfo()
            updatePriceAndName()
        }
    }

    ListModel {
        id: expiresModel
        ListElement {
            name: qsTr("Not")
        }
        ListElement {
            name: qsTr("1 day")
        }
        ListElement {
            name: qsTr("2 days")
        }
        ListElement {
            name: qsTr("3 days")
        }
    }

    Page
    {
        id: page

        y: dapMainWindow.height + height
        width: parent.width
        hoverEnabled: true

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onVisibleChanged:
        {
            if (visible)
                y = dapMainWindow.height - height
            else
                y = dapMainWindow.height + height
        }

        height: currentOrder === "Stop limit" ? 580 : 500

        background: Rectangle {
            color: currTheme.mainBackground
            radius: 30
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: currTheme.mainBackground
            }
        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 16

            font: mainFont.dapFont.bold14
            color: currTheme.white

            text: qsTr("Create order")
        }

        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            z: 1

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"
            mipmap: true

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    dapBottomPopup.hide()
                }
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 35
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 0

            RowLayout
            {
                Layout.fillWidth: true
                Layout.topMargin: 15
                Layout.minimumHeight: 35
                Layout.maximumHeight: 35

                spacing: 10

                Text
                {
                    id: textMode
//                    Layout.fillWidth: true
    //                Layout.topMargin: 10
                    height: 35
                    font: mainFont.dapFont.medium14
                    color: currTheme.white

                    text: isSell ? qsTr("Sell ") + tokenPairsWorker.tokenSell : qsTr("Buy ") + tokenPairsWorker.tokenBuy
                }


                Text
                {
                    font: mainFont.dapFont.medium14
                    color: currTheme.gray
                    text: qsTr("Balance:")
                    Layout.preferredWidth: implicitWidth
                }

                DapBigText
                {
                    id: textItem
//                    Layout.preferredWidth: textElement.width
                    Layout.fillWidth: true
//                    Layout.fillHeight: true
//                    Layout.rightMargin: 16
                    textFont: parent.textFont
                    textColor: currTheme.white
                    fullText: createLogic.unselectedTokenBalance + " " + createLogic.unselectedTokenName
            //        outSymbols: 30

            //        fullNumber: "0"
                }


/*                TwoTextBlocks
                {
                    Layout.alignment: Qt.AlignRight
//                    Layout.fillWidth: true
                    Layout.maximumHeight: 35
    //                Layout.leftMargin: 16
    //                Layout.topMargin: 10
                    label: qsTr("Balance:")
                    text: createLogic.selectedTokenBalance + " " + createLogic.selectedTokenName
                    textColor: currTheme.textColor
                    textFont: mainFont.dapFont.regular14
        //            font: mainFont.dapFont.regular14

                }*/
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.leftMargin: -10
                Layout.rightMargin: -15
                Layout.topMargin: 7
//                Layout.rightMargin: 16
                spacing: 36

                DapRadioButton
                {
                    Layout.fillWidth: true

                    indicatorInnerSize: 46
                    spaceIndicatorText: -5
                    fontRadioButton: mainFont.dapFont.regular14
                    implicitHeight: 35

                    nameRadioButton: qsTr("Limit")
                    checked: true

                    onClicked: {
                        console.log("Limit")
                        limit.visible = true
                        market.visible = false
                        stopLimit.visible = false
                        currentOrder = "Limit"
                        page.y = dapMainWindow.height - page.height
                    }
                }

                DapRadioButton
                {
                    Layout.fillWidth: true

                    indicatorInnerSize: 46
                    spaceIndicatorText: -5
                    fontRadioButton: mainFont.dapFont.regular14
                    implicitHeight: 35

                    nameRadioButton: qsTr("Market")
                    checked: false

                    onClicked: {
                        console.log("Market")
                        limit.visible = false
                        market.visible = true
                        stopLimit.visible = false
                        currentOrder = "Market"
                        page.y = dapMainWindow.height - page.height
                    }
                }

                DapRadioButton
                {
                    Layout.fillWidth: true
//                    enabled: false

                    indicatorInnerSize: 46
                    spaceIndicatorText: -5
                    fontRadioButton: mainFont.dapFont.regular14
                    implicitHeight: 35

                    nameRadioButton: qsTr("Stop limit")
                    checked: false

                    onClicked: {
                        console.log("Stop limit")
                        limit.visible = false
                        market.visible = false
                        stopLimit.visible = true
                        currentOrder = "Stop limit"
                        page.y = dapMainWindow.height - page.height
                    }
                }
            }


            OrderLimit
            {
                id: limit
                Layout.fillWidth: true
            }

            OrderMarket
            {
                id: market
                Layout.fillWidth: true
                visible: false
            }

            OrderStopLimit
            {
                id: stopLimit
                Layout.fillWidth: true
                visible: false
            }

            Item
            {
                Layout.fillHeight: true
            }
        }

//        Rectangle
//        {
//            anchors.fill: parent
//            color: "red"
//        }
    }

/*    function setStatusCreateButton(total, price)
    {
        if(price === "0" || total === "0" || total === "" || price === "")
            return false

        var totalValue = isSell ? dapMath.divCoins(dapMath.coinsToBalance(total),
                                                   dapMath.coinsToBalance(price),false):
                                  total

        var nameToken = isSell ? tokenPairsWorker.tokenBuy :
                                 tokenPairsWorker.tokenSell
        var str;


//        console.log("isSell", isSell, "\n",
//                    "total", total, "\n",
//                    "totalValue", totalValue, "\n",
//                    "price", price, "\n",
//                    "nameToken", nameToken, "\n",
//                    "selectedTokenNameWallet", logicStock.selectedTokenNameWallet, "\n",
//                    "unselectedTokenNameWallet", logicStock.unselectedTokenNameWallet, "\n",
//                    "selectedTokenBalanceWallet", logicStock.selectedTokenBalanceWallet, "\n",
//                    "unselectedTokenBalanceWallet", logicStock.unselectedTokenBalanceWallet)




        if(logicStock.selectedTokenNameWallet === nameToken)
        {
            str = dapMath.subCoins(dapMath.coinsToBalance(logicStock.selectedTokenBalanceWallet), dapMath.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        else if(logicStock.unselectedTokenNameWallet === nameToken)
        {
            str = dapMath.subCoins(dapMath.coinsToBalance(logicStock.unselectedTokenBalanceWallet), dapMath.coinsToBalance(totalValue), false)

            if(str.length < 70)
                return true
            else
                return false
        }
        else
        {
            return false
        }
    }*/

    function updateWalletInfo()
    {
        if (logicMainApp.currentWalletIndex !== -1
            && dapModelWallets.count > 0
            && dapModelWallets.get(logicMainApp.currentWalletIndex).networks.count > 0)
        {
            var currentWallet = dapModelWallets.get(logicMainApp.currentWalletIndex)

//            console.log("updateWalletInfo", currentWallet.name)

            var networkModel = dapModelWallets.get(logicMainApp.currentWalletIndex).networks
            var networkIndex = -1

//            console.log("tokenNetwork", tokenPairsWorker.tokenNetwork)

            for (var i = 0; i < networkModel.count; ++i)
            {
                if (networkModel.get(i).name === tokenPairsWorker.tokenNetwork)
                {
                    console.log("name", networkModel.get(i).name)
                    networkIndex = i
                }
            }


        }
    }

    function updatePriceAndName()
    {
        if (isSell)
        {
            createLogic.selectedTokenName = tokenPairsWorker.tokenSell
            createLogic.selectedTokenPrice = tokenPairsWorker.tokenPrice
            createLogic.unselectedTokenName = tokenPairsWorker.tokenBuy
            createLogic.unselectedTokenPrice = tokenPairsWorker.tokenReversePrice

            createLogic.selectedTokenBalance = createLogic.sellTokenBalance
            createLogic.selectedTokenBalanceText = createLogic.sellTokenBalanceText
            createLogic.unselectedTokenBalance = createLogic.buyTokenBalance
            createLogic.unselectedTokenBalanceText = createLogic.buyTokenBalanceText
        }
        else
        {
            createLogic.selectedTokenName = tokenPairsWorker.tokenBuy
            createLogic.selectedTokenPrice = tokenPairsWorker.tokenReversePrice
            createLogic.unselectedTokenName = tokenPairsWorker.tokenSell
            createLogic.unselectedTokenPrice = tokenPairsWorker.tokenPrice

            createLogic.selectedTokenBalance = createLogic.buyTokenBalance
            createLogic.selectedTokenBalanceText = createLogic.buyTokenBalanceText
            createLogic.unselectedTokenBalance = createLogic.sellTokenBalance
            createLogic.unselectedTokenBalanceText = createLogic.sellTokenBalanceText
        }
    }
}

