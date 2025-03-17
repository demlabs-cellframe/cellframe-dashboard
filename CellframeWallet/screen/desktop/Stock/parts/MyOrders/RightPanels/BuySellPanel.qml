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

    property bool isBuy: logic.selectedItem.side !== "Buy"

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
                          qsTr("Buy ") + logic.selectedItem.tokenSell :
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
                var token = logic.selectedItem.tokenBuy
                return dexModule.getBalance(token) + " " + token
            }
            textColor: currTheme.white
            textFont: mainFont.dapFont.regular14
        }

        OrderCreateFieldsComponent
        {
            id: fields
            sell: !isBuy
            logicPrice: logic.selectedItem.price
            balance: !isBuy ? dexModule.getBalance(logic.selectedItem.tokenSell)
                                : dexModule.getBalance(logic.selectedItem.tokenBuy)

            amount.textToken: dexModule.token1
            total.textToken: dexModule.token2

            price.textToken: dexModule.token2
            price.textValue: logic.selectedItem.price

            Layout.fillWidth: true

            Component.onCompleted:
            {
                show("BUY_SELL","")
            }

            function onCreateBtnClicked()
            {
                var resultAmount = !isBuy ? fields.amount.textValue : fields.total.textValue
                var resultTokenName = !isBuy ? fields.amount.textToken : fields.total.textToken 

                var walletResult = dexModule.isCreateOrder(dexModule.networkPair, resultAmount, resultTokenName)
                console.log("Wallet: " + walletResult)
                if(walletResult.code === 0)
                {
                    var createOrder = dexModule.tryExecuteOrder(logic.selectedItem.hash, resultAmount, walletModule.getFee(dexModule.networkPair).validator_fee, resultTokenName)
                    console.log("Order: " + createOrder)
                }
                else
                {
                    messageText.text = walletResult.message
                }
            }

            Connections
            {
                target: fields
                function onPercentButtonClicked(percent)
                {
                    
                    var result = dexModule.multCoins(logic.selectedItem.amount, percent)
                    if(isBuy)
                    {
                        fields.amount.textElement.text = result
                    }
                    else
                    {
                        fields.total.textElement.text = result
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
