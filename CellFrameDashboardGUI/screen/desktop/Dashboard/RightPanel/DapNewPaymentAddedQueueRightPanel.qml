import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    headerText: qsTr("Placed to queue")
    messageText: qsTr("Pending")

    doneButton.onClicked:
    {
        navigator.popPage()
    }

    Component.onCompleted:
    {
        if(commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Placed to queue")
            messageText = ""
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Error")
            messageText = commandResult.errorMessage
        }
    }
}
