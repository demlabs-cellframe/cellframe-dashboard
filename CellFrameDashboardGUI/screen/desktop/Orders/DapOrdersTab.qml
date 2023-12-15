import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"

DapPage {


    ListModel{
        id: testOrdersModel

        ListElement
        {
            location: "Location 1"
            network: "Network 1"
            node_addr: "Node Addr 1"
            price: "Price 1"
        }
        ListElement
        {
            location: "Location 2"
            network: "Network 2"
            node_addr: "Node Addr 2"
            price: "Price 2"
        }
        ListElement
        {
            location: "Location 3"
            network: "Network 3"
            node_addr: "Node Addr 3"
            price: "Price 3"
        }
        ListElement
        {
            location: "Location 4"
            network: "Network 4"
            node_addr: "Node Addr 4"
            price: "Price 4"
        }
        ListElement
        {
            location: "Location 5"
            network: "Network 5"
            node_addr: "Node Addr 5"
            price: "Price 5"
        }
        ListElement
        {
            location: "Location 6"
            network: "Network 6"
            node_addr: "Node Addr 6"
            price: "Price 6"
        }
        ListElement
        {
            location: "Location 7"
            network: "Network 7"
            node_addr: "Node Addr 7"
            price: "Price 7"
        }
    }

    dapHeader.initialItem:
        DapOrdersTopPanel
        {

        }

    dapScreen.initialItem:
        DapOrdersScreen
        {
            id: dashboardScreen
        }

    dapRightPanel.initialItem:Item{}

    Component.onCompleted:
    {
        ordersModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        ordersModule.statusProcessing = false
    }

}
