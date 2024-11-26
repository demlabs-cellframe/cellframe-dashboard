import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    headerText: qsTr("Order created\nsuccessfully")
    messageText: qsTr("")

    doneButton.onClicked: navigator.clear()

    Component.onCompleted:
    {
        if(logicOrders.commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Order created\nsuccessfully")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Creating order error")
            messageText = logicOrders.commandResult.message
        }
    }
}
