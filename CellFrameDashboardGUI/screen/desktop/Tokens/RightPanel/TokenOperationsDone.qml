import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{

    headerText: qsTr("Placed to mempool")
    messageText: qsTr("Pending")

    doneButton.onClicked:
    {
        logicTokens.unselectToken()
        navigator.clear()
    }

    Component.onCompleted:
    {
        if(logicTokens.commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Placed to mempool")
            messageText = qsTr("Pending")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Error")
            messageText = logicTokens.commandResult.message
        }
    }
}
