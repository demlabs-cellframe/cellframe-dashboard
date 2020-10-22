import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../"



Item
{
//    // Install the top panel widget
    id: tab
//    Column
//    {
        anchors.fill: parent
        DapWalletTopPanel
        {
            id: topPanel
        }

        DapTokensListView
        {
            anchors.top: topPanel.bottom
            anchors.margins: 24*pt
        }

}
