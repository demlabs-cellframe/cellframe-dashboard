import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapRightPanelDone
{
    hederText: qsTr("Wallet created\nsuccessfully")
    messageText: qsTr("Now you can manage your\nwallets in Settings")

    doneButton.onClicked: navigator.popPage()

    Component.onCompleted:
    {
        if(commandResult.success)
        {
            messageImage = iconOk
            hederText = qsTr("Wallet created\nsuccessfully")
        }
        else
        {
            messageImage = iconBad
            hederText = qsTr("Creating wallet error")
            messageText = qsTr(commandResult.message)
        }
    }
}

