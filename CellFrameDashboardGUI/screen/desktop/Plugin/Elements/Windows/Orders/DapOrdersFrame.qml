import QtQuick 2.4
import QtQuick.Controls 1.4

Rectangle {
    id:controlOrders
    anchors.fill: parent
    color: "#2E3138"

    property var dapOrders: []
    signal modelOrdersUpdated()

    ListModel
    {
        id: dapModelOrders
    }

    DapShowOrders
    {

    }


    Component.onCompleted:
    {
        dapServiceController.requestToService("DapGetListOrdersCommand");
    }

    Connections
    {
        target:dapServiceController
        onOrdersReceived:
        {
            dapOrders.splice(0,dapOrders.length)
            dapModelOrders.clear()
            for (var q = 0; q < orderList.length; ++q)
            {
                dapOrders.push(orderList[q])
            }
            for (var i = 0; i < dapOrders.length; ++i)
            {
                dapModelOrders.append({ "index" : dapOrders[i].Index,
                                      "location" : dapOrders[i].Location,
                                      "network" : dapOrders[i].Network,
                                      "node_addr" : dapOrders[i].AddrNode,
                                      "price" : dapOrders[i].TotalPrice})
            }
        }

    }
}
