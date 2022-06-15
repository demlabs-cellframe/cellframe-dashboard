import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"

DapPage
{
    id: stockTab

    dapHeader.initialItem: DapStockTopPanel
    {
        id: stockTopPanel
    }

    dapScreen.initialItem: DapStockScreen
    {
        id: stockScreen
    }

    onRightPanel: false
}
