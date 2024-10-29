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

    property string currantBalance: "0.0"
    property string currantToken: ""

    property int updateInterval: 1000

    property var resultCreate

//    property real sellMaxTotal: 1
//    property real buyMaxTotal: 1

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
}
