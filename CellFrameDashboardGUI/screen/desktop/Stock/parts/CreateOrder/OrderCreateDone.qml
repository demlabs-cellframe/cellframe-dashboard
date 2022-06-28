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
                anchors.topMargin:  150 * pt
                anchors.leftMargin: 46 * pt
                anchors.rightMargin: 50 * pt
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
                anchors.topMargin: 36 * pt
                color: "#A4A3C0"
                font: mainFont.dapFont.regular28
            }

            Text
            {
                id: textStatusMessage
                text: qsTr("Successfully")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textStatus.bottom
//                anchors.topMargin: 8 * pt
                color: currTheme.textColor
                font: mainFont.dapFont.regular28
            }

            // Button "Send"
            DapButton
            {
                id: buttonDone
                height: 36 * pt
                width: 132 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textStatusMessage.bottom
                anchors.topMargin: 190 * pt
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular16
                onClicked: goToRightHome()
            }

            Rectangle
            {
                id: rectangleBottomButton
                height: 190 * pt
                anchors.top: buttonDone.bottom
                anchors.topMargin: 24 * pt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "transparent"
            }
        }
    }
}
