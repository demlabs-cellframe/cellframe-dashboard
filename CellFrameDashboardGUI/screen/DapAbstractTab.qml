import QtQuick 2.4
import "qrc:/widgets"

DapTab
{
    ///@detalis Currently displayed right pane
    property DapRightPanel currentRightPanel

    dapSeparator.width: 1 * pt
    dapSeparator.color: "#E3E2E6"

    Connections
    {
        target: dapRightPanel
        onVisibleChanged:
        {
            rightPanel.width = dapRightPanel.visible ? 400 * pt : 0
        }
    }
}
