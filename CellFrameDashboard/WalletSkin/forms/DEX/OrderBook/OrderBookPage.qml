import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/widgets"
import "../../controls"
import "../CreateOrder"
import ".."

Rectangle
{
    color: currTheme.mainBackground

    Component.onCompleted:
    {
        updateOrdersListTimer.start()
    }

    Component.onDestruction:
    {
        updateOrdersListTimer.stop()
    }

    onHeightChanged:
    {
//        console.log("OrderBookPage",
//              height)

        orderbook.getBookVisibleCount()
    }

    Timer {
        id: updateOrdersListTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered:
        {
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        TokenPanel
        {
            Layout.fillWidth: true
        }

        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: currTheme.border
        }

        OrderBook
        {
            id: orderbook
            Layout.fillWidth: true
            Layout.fillHeight: true

        }

        ButtonPanel
        {
            Layout.fillWidth: true
        }

    }

}
