import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    headerText: qsTr("Wallet created\nsuccessfully")
    messageText: qsTr("Now you can manage your\nwallets in Settings")

    doneButton.onClicked: navigator.popPage()

    Component.onCompleted:
    {

        console.log("[TEST] commandResult.success: ", commandResult.success)
        console.log("[TEST] commandResult.message: ", commandResult.message)
        if(commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Wallet created\nsuccessfully")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Creating wallet error")
            messageText = commandResult.message
        }
    }
}

