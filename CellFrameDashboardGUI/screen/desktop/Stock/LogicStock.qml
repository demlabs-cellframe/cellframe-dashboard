import QtQuick 2.12
import QtQml 2.12

QtObject
{
    property int indexPair
    property string nameTokenPair
    property real tokenPrice
    property real tokenPrevPrice
    property string tokenPriceRounded
    property string tokenChange
    property string balanceText: balanceReal.toFixed(roundPower)
    property string cellBalanceText: cellBalanceReal.toFixed(roundPower)
    property real balanceReal
    property real cellBalanceReal

    property real sellMaxTotal: 1
    property real buyMaxTotal: 1

    function getCurrentDate(format)
    {
        var today = new Date();
        return today.toLocaleString(Qt.locale("en_EN"),format)
    }

    function initBalance()
    {
//        balanceText = fakeWallet.get(0).tokens.get(1).balance_without_zeros
//        cellBalanceText = fakeWallet.get(0).tokens.get(0).balance_without_zeros
        balanceReal = parseFloat(fakeWallet.get(0).tokens.get(1).balance_without_zeros)
        cellBalanceReal = parseFloat(fakeWallet.get(0).tokens.get(0).balance_without_zeros)
    }

    function initBookModels()
    {
        var value = 0.245978

        sellMaxTotal = 0
        buyMaxTotal = 0

        for (var i = 0; i < 18; i++)
        {
            value += Math.random()*0.0001
            var amount = Math.random()*1500
            var total = amount * value

            sellBookModel.append({ price: value,
                                   amount: amount,
                                   total: total })

            if (sellMaxTotal < total)
                sellMaxTotal = total
        }

        value = 0.245978

        for (var j = 0; j < 18; j++)
        {
            value -= Math.random()*0.0001
            var amount = Math.random()*1500
            var total = amount * value

            buyBookModel.append({ price: value,
                                   amount: amount,
                                   total: total })

            if (buyMaxTotal < total)
                buyMaxTotal = total
        }
    }

    function generateBookState()
    {
        if (Math.random() < 0.5)
        {
            var index = Math.round((Math.random()*(sellBookModel.count-1)))

            var value = sellBookModel.get(index).price
            var amount = sellBookModel.get(index).amount + Math.random()*20

            var total = amount * value

            sellBookModel.set(index, { price: value,
                                  amount: amount,
                                  total: total })

            if (sellMaxTotal < total)
                sellMaxTotal = total
        }
        else
        {
            var index = Math.round((Math.random()*(buyBookModel.count-1)))

            var value = buyBookModel.get(index).price
            var amount = buyBookModel.get(index).amount + Math.random()*20

            var total = amount * value

            buyBookModel.set(index, { price: value,
                                  amount: amount,
                                  total: total })

            if (buyMaxTotal < total)
                buyMaxTotal = total
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
                                     averagePrice: 0.259,
                                     price: 0.259,
                                     filled: "100%",
                                     amount: 247.6,
                                     total: 64.1284,
                                     triggerCondition: "-",
                                     status: "Filled"
                                   })
        orderHistoryModel.append({
                                     date: "2022-06-10 17:48",
                                     closedDate: "2022-06-13 19:36",
                                     pair: "CELL/USDT",
                                     type: "Limit",
                                     side: "Buy",
                                     averagePrice: 0.2387,
                                     price: 0.2387,
                                     filled: "100%",
                                     amount: 35,
                                     total: 8.3545,
                                     triggerCondition: ">=0.2387",
                                     status: "Filled"
                                   })
        orderHistoryModel.append({
                                     date: "2022-06-10 16:22",
                                     closedDate: "2022-06-13 12:08",
                                     pair: "CELL/USDT",
                                     type: "Limit",
                                     side: "Buy",
                                     averagePrice: 0.2241,
                                     price: 0.2241,
                                     filled: "44%",
                                     amount: 185.4,
                                     total: 41.54814,
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
            value = balanceReal - _amount * logicStock.tokenPrice
            fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()
            balanceReal = value

            if(_type === "Market")
            {
                cellBalance = cellBalanceReal + _amount
                fakeWallet.get(0).tokens.get(0).balance_without_zeros = cellBalance.toString()
                cellBalanceReal = cellBalance
            }
        }
        else
        {
            if(_type === "Market")
            {
                value = balanceReal + _amount * logicStock.tokenPrice
                fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()

                cellBalance = cellBalanceReal - _amount
                fakeWallet.get(0).tokens.get(0).balance_without_zeros = cellBalance.toString()

                balanceReal = value
                cellBalanceReal = cellBalance
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
                                       total: 0,
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
                                         total: _amount * _price,
                                         triggerCondition: _trigger,
                                         status: "Filled"
                                       })
        }
    }

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
            value = balanceReal + order.amount * logicStock.tokenPrice
            fakeWallet.get(0).tokens.get(1).balance_without_zeros = value.toString()
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
}