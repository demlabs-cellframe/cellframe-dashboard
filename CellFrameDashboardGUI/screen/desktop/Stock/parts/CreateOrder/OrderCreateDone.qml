import QtQuick 2.4
import QtQml 2.12

import "../../../controls"

DapRightPanelDone {

    headerText: qsTr("Order created\nsuccessfully!")
    messageText: qsTr("Click on «Orders» to view\nthe status of your order")

    doneButton.onClicked: goToRightHome()

    Component.onCompleted:
    {
        console.log(logicStock.resultCreate.success)

        if(logicStock.resultCreate.success)
        {
            messageImage = iconOk
            headerText = qsTr("Order created\nsuccessfully!")
        }
        else
        {
            logicStock.resultCreate = iconBad
            headerText = qsTr("Order creation\nerror!")
            messageText = logicStock.resultCreate.message
        }
    }
}
