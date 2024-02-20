import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../../../controls"
import "../../Chart"
import "../../CreateOrder"

DapRectangleLitAndShaded {
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

//    property var currentElement: logic.selectedItem

    property bool isBuy: logic.selectedItem.side === "Buy"

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42
            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20
                width: 20
                heightImage: 20
                widthImage: 20

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: logic.closedDetails()
            }

            Text
            {
                id: textHeader
                text: isBuy ?
                          qsTr("Buy ") + logic.selectedItem.tokenBuy :
                          qsTr("Sell ") + logic.selectedItem.tokenBuy
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        TwoTextBlocks
        {
            id: balanceInfo
            Layout.fillWidth: true
            Layout.maximumHeight: 20
            Layout.leftMargin: 16
            Layout.topMargin: 10
            label: qsTr("Balance:")
            text:
            {
                if(!isBuy)
                {
                    var tokenBuy = logic.selectedItem.tokenBuy
                    return walletModule.getBalanceDEX(tokenBuy) + " " + tokenBuy
                }
                else
                {
                    var tokenSell = logic.selectedItem.tokenSell
                    return walletModule.getBalanceDEX(tokenSell) + " " + tokenSell
                }
            }
            textColor: currTheme.white
            textFont: mainFont.dapFont.regular14
        }

        OrderCreateFieldsComponent
        {
            id: fields
            sell: !isBuy
            logicPrice: logic.selectedItem.price
            balance: isBuy ? walletModule.getBalanceDEX(logic.selectedItem.tokenSell) 
                                : walletModule.getBalanceDEX(logic.selectedItem.tokenBuy)

            price.textToken: logic.selectedItem.tokenSell
            price.textValue: logic.selectedItem.price
            amount.textToken: tokenPairsWorker.tokenBuy
            amount.textValue: "0.0"
            Layout.fillWidth: true

            Component.onCompleted:
            {
                show("BUY_SELL","")
            }

            function onCreateBtnClicked()
            {
                var walletResult = walletModule.isCreateOrder(dexModule.networkPair, fields.amount.textValue, fields.amount.textToken)
                console.log("Wallet: " + walletResult)
                if(walletResult === "OK")
                {
                    var createOrder = dexModule.tryExecuteOrder(logic.selectedItem.hash, fields.amount.textValue, walletModule.getFee(dexModule.networkPair).validator_fee)
                    console.log("Order: " + createOrder)
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
