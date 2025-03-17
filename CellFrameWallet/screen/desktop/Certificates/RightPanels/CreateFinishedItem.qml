import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../parts"

import "../../controls"


DapRightPanelDone {
    id: root

    property bool accept
    property string titleText
    property string contentText

    headerText: titleText
    messageText: contentText

    doneButton.textButton: {if (accept) return qsTr("Done")
        else return qsTr("Back")}

    doneButton.onClicked:
        {
            if (accept)
                certificateNavigator.clearRightPanel()
            else dapRightPanel.pop()
        }

    Component.onCompleted:
    {
        if (accept)
            messageImage = iconOk
        else messageImage = iconBad
    }
}   //root
