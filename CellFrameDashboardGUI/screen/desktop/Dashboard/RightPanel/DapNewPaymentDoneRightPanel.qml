import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    hederText: qsTr("Placed to mempool")
    messageText: qsTr("Pending")

    doneButton.onClicked:
    {
        dapServiceController.requestToService("DapGetWalletsInfoCommand");
        navigator.popPage()
    }

    Component.onCompleted:
    {
        if(commandResult.success)
        {
            messageImage = iconOk
            hederText = qsTr("Placed to mempool")
            messageText = qsTr("Pending")
        }
        else
        {
            messageImage = iconBad
            hederText = qsTr("Error")
            messageText = commandResult.errorMessage
        }
    }
}
