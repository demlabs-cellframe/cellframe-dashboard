import QtQuick 2.12
import QtQml 2.12

QtObject
{

    function initBookModels()
    {
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        sellBookModel.append({ price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })

        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })
        buyBookModel.append({  price: 0.2911,
                               amount: 23452.23,
                               total: 573.45677 })

    }

    function initOrderLists()
    {
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Stop limit",
                                   side: "Sell",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "100%",
                                   total: "1000.11",
                                   triggerCondition: ">=12,214",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Limit",
                                   side: "Buy",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "92%",
                                   total: "1000.11",
                                   triggerCondition: "-",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Stop limit",
                                   side: "Sell",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "100%",
                                   total: "1000.11",
                                   triggerCondition: ">=12,214",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Limit",
                                   side: "Buy",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "92%",
                                   total: "1000.11",
                                   triggerCondition: "-",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Stop limit",
                                   side: "Sell",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "100%",
                                   total: "1000.11",
                                   triggerCondition: ">=12,214",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Limit",
                                   side: "Buy",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "92%",
                                   total: "1000.11",
                                   triggerCondition: "-",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Stop limit",
                                   side: "Sell",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "100%",
                                   total: "1000.11",
                                   triggerCondition: ">=12,214",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Limit",
                                   side: "Buy",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "92%",
                                   total: "1000.11",
                                   triggerCondition: "-",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Stop limit",
                                   side: "Sell",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "100%",
                                   total: "1000.11",
                                   triggerCondition: ">=12,214",
                                   expiresIn: "3 days" })
        openOrdersModel.append({   date: "2022-12-15 18:40",
                                   pair: "CELL/ETH",
                                   type: "Limit",
                                   side: "Buy",
                                   price: "11,2241",
                                   amount: "204,241",
                                   filled: "92%",
                                   total: "1000.11",
                                   triggerCondition: "-",
                                   expiresIn: "3 days" })

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

}
