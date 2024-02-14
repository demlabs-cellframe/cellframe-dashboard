import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    headerText: qsTr("Placed to mempool")
    messageText: qsTr("Pending")

    doneButton.onClicked:
    {
        console.log(" DONE + dapRightPanel.clear()")
        navigator.popPage()
    }

    Component.onCompleted:
    {
        console.log(" onCompleted DapNewPaymentDoneRightPanel")
        if(commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Placed to mempool")
            messageText = qsTr("Pending")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Error")
            messageText = commandResult.errorMessage
        }
    }

    Component.onDestruction:
    {
        console.log(" onDestruction DapNewPaymentDoneRightPanel")
    }
}
