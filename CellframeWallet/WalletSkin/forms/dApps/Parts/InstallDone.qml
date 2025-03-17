import QtQuick 2.4
import QtQml 2.12

import "../../controls"

DapDoneScreen
{
    headerText: qsTr("App \n successfuly installed!")
    messageText: qsTr("")

    pageHeight: 550

    doneButton.onClicked: dapBottomPopup.hide()


    Component.onCompleted:
    {
        if(logicMainApp.commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr(logicMainApp.commandResult.errorMessage)
        }
        else
        {
            messageImage = iconBad
            headerText = logicMainApp.commandResult.headerText
            messageText = logicMainApp.commandResult.errorMessage
        }
    }
}
