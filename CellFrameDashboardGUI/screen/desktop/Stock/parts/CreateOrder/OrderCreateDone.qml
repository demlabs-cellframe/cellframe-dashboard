import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.4
import "qrc:/widgets"

Page {

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
                text: qsTr("Creating an order")
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin:  150
                anchors.leftMargin: 46
                anchors.rightMargin: 50
                color: currTheme.textColor
                font: mainFont.dapFont.medium27
            }

            Text
            {
                id: textStatus
                text: qsTr("Status")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textMessage.bottom
                anchors.topMargin: 36
                color: "#A4A3C0"
                font: mainFont.dapFont.regular28
            }

            Text
            {
                id: textStatusMessage
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textStatus.bottom
//                anchors.topMargin: 8
                color: currTheme.textColor
                font: mainFont.dapFont.regular28
            }

            Text
            {
                id: textResult
                visible: false
                horizontalAlignment: Text.AlignHCenter
                anchors.top: textStatusMessage.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.right: parent.right
                wrapMode: Text.WordWrap
//                anchors.topMargin: 8
                color: currTheme.textColor
                font: mainFont.dapFont.regular18
            }

            DapButton
            {
                id: buttonDone
                height: 36
                width: 132
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textStatusMessage.bottom
                anchors.topMargin: 190
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
                onClicked:
                {
                    dapServiceController.requestToService("DapGetWalletInfoCommand",
                        dapModelWallets.get(logicMainApp.currentIndex).name,
                        logicMainApp.networkArray);

                    goToRightHome()
                }
            }

            Rectangle
            {
                id: rectangleBottomButton
                height: 190
                anchors.top: buttonDone.bottom
                anchors.topMargin: 24
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
    }

    Component.onCompleted:
    {
        if(logicStock.resultCreate.success)
            textStatusMessage.text = qsTr("Successfully")
        else
        {
            textStatusMessage.text = qsTr("Error")
            textResult.text = qsTr(logicStock.resultCreate.message)
            textResult.visible = true
        }
    }
}
