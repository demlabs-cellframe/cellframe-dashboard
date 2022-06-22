import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"

DapPage
{
    id: stockTab

    LogicStock{id: logicStock}

    ListModel{ id: sellBookModel}
    ListModel{ id: buyBookModel}
    ListModel{ id: openOrdersModel}
    ListModel{ id: orderHistoryModel}
    ListModel{ id: pairModel}

    dapScreen.initialItem: DapStockScreen
    {
        id: stockScreen
    }

    dapHeader.initialItem: DapStockTopPanel
    {
        id: stockTopPanel
    }

    onRightPanel: false
}
