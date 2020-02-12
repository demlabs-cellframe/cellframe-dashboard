import QtQuick 2.4

DapAbstractTabForm
{
    Connections
    {
        target: dapRightPanel
        onVisibleChanged:
        {
            rightPanel.width = dapRightPanel.visible ? 400 * pt : 0
        }
    }
}
