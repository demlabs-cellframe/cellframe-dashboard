import QtQuick 2.4
import QtQml 2.12

import "../../../controls"

DapRightPanelDone {

    headerText: qsTr("Order created\nsuccessfully!")
    messageText: qsTr("Click on «My orders» to view\nthe status of your order")

    doneButton.onClicked: goToRightHome()

    Component.onCompleted:
    {
        if(commandResult.success)
        {
            messageImage = iconOk
            headerText = qsTr("Order created\nsuccessfully!")
        }
        else
        {
            messageImage = iconBad
            headerText = qsTr("Order creation\nerror!")
            messageText = qsTr(logicStock.resultCreate.message)
        }
    }
}
