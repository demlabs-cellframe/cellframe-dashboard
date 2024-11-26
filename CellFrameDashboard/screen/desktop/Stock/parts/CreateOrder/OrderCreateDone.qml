import QtQuick 2.4
import QtQml 2.12

import "../../../controls"

DapRightPanelDone {

    headerText: qsTr("Order created\nsuccessfully!")
    messageText: qsTr("Click on «Orders» to view\nthe status of your order")

    doneButton.onClicked:
    {
        goToRightHome()
    }

    Component.onCompleted:
    {
        console.log(logicStock.resultCreate.success)
        if(logicStock.resultCreate.success)
        {
            messageImage = iconOk

            if(logicStock.resultCreate.toQueue)
            {
                headerText = qsTr("Placed to queue")
                messageText = ""
            }
            else
            {
                headerText = qsTr("Order created\nsuccessfully!")
            }

        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Order creation\nerror!")
            messageText = logicStock.resultCreate.message
        }
    }
}
