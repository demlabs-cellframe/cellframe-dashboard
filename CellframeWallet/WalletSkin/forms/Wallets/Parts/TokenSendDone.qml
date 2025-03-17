import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapDoneScreen
{
    headerText: qsTr("Placed to mempool")
    messageText: qsTr("Pending")

    pageHeight: 401

    doneButton.onClicked: dapBottomPopup.hide()


    Component.onCompleted:
    {
        if(logicMainApp.commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Placed to mempool")
            messageText = qsTr("Pending")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Error")
            messageText = logicMainApp.commandResult.errorMessage
        }
    }
}
