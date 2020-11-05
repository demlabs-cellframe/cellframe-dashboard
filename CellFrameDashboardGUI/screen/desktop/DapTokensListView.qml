import QtQuick 2.0

Rectangle
{
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    border.color: "#E2E1E6"
    border.width: 1 * pt
    radius: 8 * pt

    ListView
    {
        model: app.currentWallet()
    }
}
