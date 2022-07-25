import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5 as Controls
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.4
import "qrc:/widgets"
import "../../../"

Controls.Page
{

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item {

            Layout.fillWidth: true
            Layout.fillHeight: true

            Text
            {
                id: textMessage
                text: qsTr("Placed to mempool")
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin:  150 * pt
                anchors.leftMargin: 46 * pt
                anchors.rightMargin: 50 * pt
                color: currTheme.textColor
                font: mainFont.dapFont.medium27
            }

            // Button "Send"
            DapButton
            {
                id: buttonSend
                height: 36 * pt
                width: 132 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textMessage.bottom
                anchors.topMargin: 190 * pt
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
                onClicked:
                {
                    logicTokens.unselectToken()
                    navigator.clear()
                }
            }

            Rectangle
            {
                id: rectangleBottomButton
                height: 190 * pt
                anchors.top: buttonSend.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
    }

    Component.onCompleted:
    {
        if(logicTokens.commandResult.success)
        {
            textMessage.text = qsTr("Placed in datum pool")
        }
        else
        {
            textMessage.text = qsTr("Error")
        }
    }
}
