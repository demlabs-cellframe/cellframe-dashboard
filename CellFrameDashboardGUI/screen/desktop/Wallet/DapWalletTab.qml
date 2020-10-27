import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../"



Item
{
    id: tab
    Column
    {
        anchors.fill: parent

        DapWalletTopPanel
        {
            id: topPanel
        }

        Item {
            height: parent.height - topPanel.height
            width: parent.width

            DapTokensListView
            {
                anchors.margins: 24*pt
                anchors.right: rightPanel.left
            }
            DapRightPanel_New
            {
                id: rightPanel
                stackView.initialItem: firstPage
                Component.onCompleted: stackView.push(secondPage)
            }
            Component
            {
                id:firstPage
                Rectangle{
                    color: "#ff0000"
                }
            }
            Component
            {
                id:secondPage
                Rectangle{
                    color: "#00ff62"
                }
            }
        }
    }
}
