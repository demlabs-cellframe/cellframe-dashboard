import QtQuick 2.12
import QtQml 2.12

QtObject
{
//    property string tokenChange: ""
    property real balanceReal
    property real cellBalanceReal
//    property string balanceText: balanceReal.toFixed(roundPower)
//    property string cellBalanceText: cellBalanceReal.toFixed(roundPower)
    property string selectedTokenNameWallet:""
    property string selectedTokenBalanceWallet:"0"
    property string unselectedTokenNameWallet:""
    property string unselectedTokenBalanceWallet:"0"

    property int updateInterval: 1000

    property var resultCreate

//    property real sellMaxTotal: 1
//    property real buyMaxTotal: 1

    function cancelationOrder(index)
    {
        var order = openOrdersModel.get(index)
        orderHistoryModel.insert(0,{
                                     date: order.date,
                                     closedDate: logicMainApp.getDate("yyyy-MM-dd hh:mm"),
                                     pair: order.pair,
                                     type: order.type,
                                     side: order.side,
                                     averagePrice: order.price,
                                     price: order.price,
                                     filled: order.filled,
                                     amount: order.amount,
                                     total: order.total,
                                     triggerCondition: order.triggerCondition,
                                     status: "Cancelled"
                                   })

        var value

        if(order.side === "Buy")
        {
            value = balanceReal + order.amount * logicMainApp.tokenPrice
            fakeWallet.get(0).tokens.get(1).coins = value.toString()
            balanceReal = value

            fakeWalletChanged() //for top panel
        }

        openOrdersModel.remove(index)
    }

    function getBookVisibleCount(heightParent)
    {
        var count = (heightParent - 42)/32/2 - 1
        return Math.floor(count)
    }

    function searchOrder(net, tokenSell, tokenBuy, price, amountSell, amountBuy)
    {
        for(var i = 0; i < dapModelXchangeOrders.count; i++)
        {
            console.log(net, dapModelXchangeOrders.get(i).network)

            if(net === dapModelXchangeOrders.get(i).network)
            {
                for(var j = 0; j < dapModelXchangeOrders.get(i).orders.count; j++)
                {
                    var orderNet = dapModelXchangeOrders.get(i).network
                    var orderBuy = dapModelXchangeOrders.get(i).orders.get(j).buy_token
                    var orderSell = dapModelXchangeOrders.get(i).orders.get(j).sell_token
                    var orderPrice = parseFloat(dapModelXchangeOrders.get(i).orders.get(j).rate)
                    var orderSellAmount = dapModelXchangeOrders.get(i).orders.get(j).sell_amount
                    var orderBuyAmount = dapModelXchangeOrders.get(i).orders.get(j).buy_amount
                    var orderHash = dapModelXchangeOrders.get(i).orders.get(j).order_hash

//                    console.log("-------")
//                    console.log("order_buy", orderBuy,               "user_sell",tokenSell,"\n",
//                                "order_sell",orderSell,              "user_buy",tokenBuy,"\n",
//                                "order_price",orderPrice,            "user_price",price,"\n",
//                                "order_sell_amount",orderSellAmount, "user_buy_amount",amountBuy,"\n",
//                                "order_buy_amount",orderBuyAmount,   "user_sell_amount",amountSell,"\n")

                    if(orderBuy === tokenSell && orderSell === tokenBuy)
                    {
                        if(tokenPairsWorker.tokenBuy === tokenBuy)
                        {
                            if(1/orderPrice === price &&
                               orderSellAmount >= amountBuy)
                            {
                                console.log("HASH:", orderHash)
                                return orderHash
                            }
                        }
                        else
                        {
                            if(orderPrice === 1/price &&
                               orderSellAmount >= amountBuy)
                            {
                                console.log("HASH:", orderHash)
                                return orderHash
                            }
                        }
                    }
                }
            }
        }
        console.log("HASH: 0")
        return "0"
    }

    function getPercentBalance(percent, price, isSell)
    {
        if(price === 0)
            return price

        var balanceToken

        if(isSell)
            balanceToken = selectedTokenNameWallet === tokenPairsWorker.tokenBuy ?
                           selectedTokenBalanceWallet : unselectedTokenBalanceWallet
        else
            balanceToken = selectedTokenNameWallet === tokenPairsWorker.tokenBuy ?
                           unselectedTokenBalanceWallet : selectedTokenBalanceWallet

        var balanceDatoshi = mathWorker.coinsToBalance(balanceToken)
        var percentDatoshi = mathWorker.coinsToBalance(percent)
        var priceDatoshi = mathWorker.coinsToBalance(price)

        var multRes = mathWorker.multCoins(balanceDatoshi, percentDatoshi, false)

        var result = [2]

        result[0] = isSell? multRes: mathWorker.divCoins(mathWorker.coinsToBalance(multRes),
                                                      priceDatoshi, false)

        result[1] = isSell? mathWorker.multCoins(mathWorker.coinsToBalance(multRes),
                                              priceDatoshi, false) : multRes

        return result
    }

    function walletListUpdate(walletList)
    {
        for(var i = 0; i < walletList.length; i++)
            walletListModel.append({name: walletList[i]})

    }
}
