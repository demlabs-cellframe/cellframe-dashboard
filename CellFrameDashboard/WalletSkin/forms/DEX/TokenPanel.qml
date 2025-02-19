import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "DapPairComboBox"
import "qrc:/widgets"

Item
{
    id: tokenPanel

    height: layout.height

    property real volume24h: 0.0

    signal tokenPairChanged()

    Component.onCompleted:
    {
        updateTokenPrice()
    }

    ColumnLayout
    {
        id: layout
        width: parent.width
//                             anchors.fill: parent
        spacing: 0

        RowLayout
        {
            Layout.fillWidth: true
            height: 85

            spacing: 0

            ColumnLayout
            {
                Layout.fillHeight: true
                Layout.leftMargin: 16
                Layout.maximumWidth: 150
                spacing: 0

                DapPairComboBox
                {
                    property bool isInit: false
                    property var globalIndex
                    id: pairBox
                    Layout.minimumWidth: 150
                    Layout.maximumHeight: 25
                    Layout.minimumHeight: 25

//                                    height: 32

                    onInitModelIsCompleted: {
                        isInit = true
                        currentIndex = tokenPairsWorker.currentPairIndex
                        globalIndex = currentIndex
                        displayElement = dapPairModel[globalIndex]
                        updateInfo(globalIndex)
                    }

                    Component.onCompleted:
                    {
                        logic.setModel(dapPairModel)

                    }
                    
                    onCurrentIndexChanged: /* no call*/ {

                        if(isInit)
                        {
                            for(var i = 0; i < dapPairModel.length; i++)
                            {
                                if(dapPairModel[i].tokenBuy === pairBox.displayElement.tokenBuy &&
                                   dapPairModel[i].tokenSell === pairBox.displayElement.tokenSell)
                                {
                                    globalIndex = i
                                }
                            }

                            if(globalIndex !== -1)
                                updateInfo(globalIndex)
                        }
                    }

                    function updateInfo(currentIndex)
                    {
    //                    tokenPairsWorker.currentPairIndex = currentIndex

                        tokenPairsWorker.setCurrentPairIndex(currentIndex)

                        console.log("updateInfo",
                                    tokenPairsWorker.currentPairIndex,
                                    dapPairModel.length,
                                    dapPairModel[currentIndex].tokenBuy,
                                    dapPairModel[currentIndex].tokenSell,
                                    tokenPairsWorker.tokenBuy,
                                    tokenPairsWorker.tokenSell)

                        logicMainApp.tokenPrice = tokenPairsWorker.tokenPrice
                        logicMainApp.tokenPriceText = tokenPairsWorker.tokenPriceText
    //                    logicMainApp.tokenPrice = dapPairModel[currentIndex].price
    //                    logicMainApp.tokenPriceText = dapPairModel[currentIndex].priceText

                        tokenPairChanged()
                    }

                    Connections
                    {
                        target: tokenPairsWorker
                        onPairModelUpdated:
                        {
                            if(!pairBox.count)
                                pairBox.logic.setModel(dapPairModel)
                            else
                            {
                                pairBox.currentIndex = tokenPairsWorker.currentPairIndex
                                pairBox.displayElement = dapPairModel[tokenPairsWorker.currentPairIndex]
                            }
                        }
                    }
                }

//                                Text {
//                                    text: candleChartWorker.currentTokenPriceText
//                                }

                DapBigNumberText
                {
                    id: tokenPriceText
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    height: 30
                    textFont: mainFont.dapFont.medium24
                    textColor: currTheme.green
                    outSymbols: 15
                    fullNumber: candleChartWorker.currentTokenPriceText
                    copyButtonVisible: true
                }

                Text {
                    id: tokenPriceChange
                    Layout.topMargin: 5

                    font: mainFont.dapFont.medium12
                    text: "0.0%"
                    color: currTheme.green
                }

            }

            ColumnLayout
            {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.rightMargin: 16
                spacing: 5

                RowLayout
                {
                    Text
                    {
                        Layout.fillWidth: true
                        font: mainFont.dapFont.medium12
                        color: currTheme.gray
                        text: qsTr("24h Hight")
                    }

                    Text
                    {
                        id: max24hText
                        font: mainFont.dapFont.regular12
                        color: currTheme.white
                        text: candleChartWorker.maximum24h.toFixed(roundPower)
                    }
                }

                RowLayout
                {
                    Text
                    {
                        Layout.fillWidth: true
                        font: mainFont.dapFont.medium12
                        color: currTheme.gray
                        text: qsTr("24h Low")
                    }

                    Text
                    {
                        id: min24hText
                        font: mainFont.dapFont.regular12
                        color: currTheme.white
                        text: candleChartWorker.minimum24h.toFixed(roundPower)
                    }
                }

                RowLayout
                {
                    Text
                    {
                        Layout.fillWidth: true
                        font: mainFont.dapFont.medium12
                        color: currTheme.gray
                        text: qsTr("24h Volume")
                    }

                    Text
                    {
                        font: mainFont.dapFont.regular12
                        color: currTheme.white
                        text: volume24h.toFixed(2) + " " + tokenPairsWorker.tokenBuy
                    }
                }


            }
        }

        Item {
            Layout.minimumHeight: 10
        }
    }

    Connections{
        target: candleChartWorker
        onCurrentTokenPriceChanged:
        {
//            console.log("TokenPanel", "onCurrentTokenPriceChanged")

            updateTokenPrice()
        }
    }

    function updateTokenPrice()
    {
        var sign = ""

        if (candleChartWorker.currentTokenPrice <
            candleChartWorker.previousTokenPrice)
        {
            tokenPriceText.textColor = currTheme.red
            tokenPriceChange.color = currTheme.red
        }
        else
        {
            tokenPriceText.textColor = currTheme.green
            tokenPriceChange.color = currTheme.green
            sign = "+"
        }

        var change = 0

        if (candleChartWorker.previousTokenPrice > 0.00000000000000001)
            change = (candleChartWorker.currentTokenPrice -
                      candleChartWorker.previousTokenPrice)/
                    candleChartWorker.previousTokenPrice*100

        tokenPriceChange.text = sign + change.toFixed(5) + "%"
    }
}

