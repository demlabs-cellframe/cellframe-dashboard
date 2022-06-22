import QtQuick 2.12
import QtQml 2.12

QtObject
{
    property int indexPair
    property string nameTokenPair
    property string tokenPrice
    property string tokenChange

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
        for(var i = 0; i < 12; i++)
        {
//            openOrdersModel.append({   date: "2022-12-15 18:40",
//                                       pair: "CELL/ETH",
//                                       type: "Stop limit",
//                                       side: "Sell",
//                                       price: "11,2241",
//                                       amount: "204,241",
//                                       filled: "100%",
//                                       total: "1000.11",
//                                       triggerCondition: ">=12,214",
//                                       expiresIn: "3 days" })

//            openOrdersModel.append({   date: "2022-12-15 18:40",
//                                       pair: "CELL/ETH",
//                                       type: "Limit",
//                                       side: "Buy",
//                                       price: "11,2241",
//                                       amount: "204,241",
//                                       filled: "92%",
//                                       total: "1000.11",
//                                       triggerCondition: "-",
//                                       expiresIn: "3 days" })

            orderHistoryModel.append({
                                         date: "2022-12-15 18:40",
                                         closedDate: "2022-12-18 06:50",
                                         pair: "CELL/ETH",
                                         type: "Stop limit",
                                         side: "Sell",
                                         averagePrice: "10.224",
                                         price: "11,2241",
                                         filled: "100%",
                                         amount: "204,241",
                                         total: "1000.11",
                                         triggerCondition: ">=12,214",
                                         status: "Filled"
                                       })
            orderHistoryModel.append({
                                         date: "2022-12-10 16:22",
                                         closedDate: "2022-12-13 12:08",
                                         pair: "CELL/ETH",
                                         type: "Limit",
                                         side: "Buy",
                                         averagePrice: "10.224",
                                         price: "11,2241",
                                         filled: "44%",
                                         amount: "105,241",
                                         total: "218.11",
                                         triggerCondition: ">=12,214",
                                         status: "Cancelled"
                                       })

        }
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
                         _amount, _expiresIn)
    {
        print("addNewOrder", _date, _pair, _type, _side, _price,
              _amount, _expiresIn)

        openOrdersModel.append({   date: _date,
                                   pair: _pair,
                                   type: _type,
                                   side: _side,
                                   price: _price,
                                   amount: _amount,
                                   filled: "0%",
                                   total: "0",
                                   triggerCondition: "-",
                                   expiresIn: _expiresIn })
    }

    function getBookVisibleCount(heightParent)
    {
        var count = (heightParent - 42)/32/2 - 1
        return Math.floor(count)
    }
}
