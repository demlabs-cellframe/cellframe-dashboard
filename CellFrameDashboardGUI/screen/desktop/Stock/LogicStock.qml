import QtQuick 2.12
import QtQml 2.12

QtObject
{
    property int indexPair
    property string nameTokenPair
    property string tokenPrice
    property string tokenChange
    property string balanceValue: fakeWallet.get(0).tokens.get(1).balance_without_zeros
    property string cellBalanceValue: fakeWallet.get(0).tokens.get(0).balance_without_zeros

    function getCurrentDate(format)
    {
        var today = new Date();
        return today.toLocaleString(Qt.locale("en_EN"),format)
    }

    function initBookModels()
    {
        for(var i = 0; i < 24; i++)
        {
            var val = (0.2914 + 0.1*i).toFixed(4)
            var amountSell = (Math.random() * (10000/(24-i) - 50*(24-i)) + 50*(24-i)).toFixed(0)
            var amountBuy = (Math.random() * (10000/(24-i) - 50*(24-i)) + 50*(24-i)).toFixed(0)
            var totalSell = (amountSell * val).toFixed(4)
            var totaBuy = (amountBuy * val).toFixed(4)

            sellBookModel.append({ price: val,
                                   amount: amountSell,
                                   total: totalSell })
            buyBookModel.append({  price: val,
                                   amount: amountBuy,
                                   total: totaBuy })
        }
    }

    function initOrderLists()
    {
        orderHistoryModel.append({
                                     date: "2022-06-18 14:50",
                                     closedDate: "2022-06-18 14:50",
                                     pair: "CELL/USDT",
                                     type: "Market",
                                     side: "Sell",
                                     averagePrice: "0,259",
                                     price: "0,259",
                                     filled: "100%",
                                     amount: "247.6",
                                     total: "64.1284",
                                     triggerCondition: "-",
                                     status: "Filled"
                                   })
        orderHistoryModel.append({
                                     date: "2022-06-10 17:48",
                                     closedDate: "2022-06-13 19:36",
                                     pair: "CELL/USDT",
                                     type: "Limit",
                                     side: "Buy",
                                     averagePrice: "0,2387",
                                     price: "0,2387",
                                     filled: "100%",
                                     amount: "35",
                                     total: "8.3545",
                                     triggerCondition: ">=0.2387",
                                     status: "Filled"
                                   })
        orderHistoryModel.append({
                                     date: "2022-06-10 16:22",
                                     closedDate: "2022-06-13 12:08",
                                     pair: "CELL/USDT",
                                     type: "Limit",
                                     side: "Buy",
                                     averagePrice: "0,2241",
                                     price: "0,2241",
                                     filled: "44%",
                                     amount: "185.4",
                                     total: "41.54814",
                                     triggerCondition: ">=0.2241",
                                     status: "Cancelled"
                                   })
    }

    function initPairModel()
    {
        pairModel.append({ pair: "CELL/USDT",
                           price: "0.245978",
                           change: "+5.16 %"
                         })
        pairModel.append({ pair: "CELL/BNB",
                           price: "0.00110722",
                           change: "-0.04 %"
                         })
        pairModel.append({ pair: "CELL/ETH",
                           price: "0.000210952",
                           change: "+1.47 %"
                         })
        pairModel.append({ pair: "CELL/DAI",
                           price: "0.245852",
                           change: "+5.22 %"
                         })
    }

    function addNewOrder(_date, _pair, _type, _side, _price,
                         _amount, _expiresIn, _trigger)
    {
        print("addNewOrder", _date, _pair, _type, _side, _price,
              _amount, _expiresIn, _trigger)

        var value
        var cellBalance

        if(_side === "Buy")
        {
            value = parseFloat(balanceValue) - (parseFloat(_amount) * parseFloat(logicStock.tokenPrice))
            fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()
            balanceValue = value

            if(_type === "Market")
            {
                cellBalance = parseFloat(cellBalanceValue) + parseFloat(_amount)
                fakeWallet.get(0).tokens.get(0).balance_without_zeros = cellBalance.toString()
                cellBalanceValue = cellBalance
            }
        }
        else
        {
            if(_type === "Market")
            {
                value = parseFloat(balanceValue) + (parseFloat(_amount) * parseFloat(logicStock.tokenPrice))
                fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()

                cellBalance = parseFloat(cellBalanceValue) - parseFloat(_amount)
                fakeWallet.get(0).tokens.get(0).balance_without_zeros = cellBalance.toString()

                balanceValue = value
                cellBalanceValue = cellBalance
            }
        }

        fakeWalletChanged() //for top panel

        if(_type !== "Market")
            openOrdersModel.insert(0,{ date: _date,
                                       pair: _pair,
                                       type: _type,
                                       side: _side,
                                       price: _price,
                                       amount: _amount,
                                       filled: "0%",
                                       total: "0",
                                       triggerCondition: _trigger,
                                       expiresIn: _expiresIn })
        else
        {
            orderHistoryModel.insert(0,{
                                         date: _date,
                                         closedDate: _date,
                                         pair: _pair,
                                         type: _type,
                                         side: _side,
                                         averagePrice: _price,
                                         price: _price,
                                         filled: "100%",
                                         amount: _amount,
                                         total: (_amount * _price).toString(),
                                         triggerCondition: _trigger,
                                         status: "Filled"
                                       })
        }
    }

    function cancelationOrder(index)
    {
        var order = openOrdersModel.get(index)
        var date = new Date()
        var closedDate = date.toLocaleString(Qt.locale("en_EN"),"yyyy-MM-dd hh:mm")

        orderHistoryModel.insert(0,{
                                     date: order.date,
                                     closedDate: closedDate,
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
            value = parseFloat(balanceValue) + (parseFloat(order.amount) * parseFloat(logicStock.tokenPrice))
            fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()
            balanceValue = value

            fakeWalletChanged() //for top panel
        }

        openOrdersModel.remove(index)
    }



    function getBookVisibleCount(heightParent)
    {
        var count = (heightParent - 42)/32/2 - 1
        return Math.floor(count)
    }
}
