import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapDoneScreen
{
    headerText: qsTr("Wallet created\nsuccessfully")
    messageText: qsTr("Now you can manage your\nwallets in Settings")

    pageHeight: 401

    doneButton.onClicked: dapBottomPopup.hide()

    Component.onCompleted:
    {
        if(logicMainApp.commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Wallet created\nsuccessfully!")
            result = qsTr("Successfully!")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Creating wallet error")
            messageText = logicMainApp.commandResult.message
            result = qsTr("Error")
        }
    }
}

