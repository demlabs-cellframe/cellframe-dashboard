import QtQuick 2.0
import QtQuick.Controls 2.0
import "../../"
import "../"

DapUiQmlScreen {
    property alias pressedDoneNewPaymentButton: doneButton.pressed

    id: newPaymentStatus
    width: 640 * pt
    height: 800 * pt
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    Text {
        id: mempoolText
        text: qsTr("Placed to mempool")
        color: "#505559"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 236 * pt
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 28 * pt
        font.family: "Roboto"
        font.weight: Font.Normal
    }

    Text {
        id: statusText
        text: qsTr("Status")
        color: "#989898"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mempoolText.bottom
        anchors.topMargin: 56 * pt
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 22 * pt
        font.family: "Roboto"
        font.weight: Font.Normal
    }

    Text {
        id: pendingText
        text: qsTr("Pending")
        color: "#505559"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: statusText.bottom
        anchors.topMargin: 16 * pt
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 28 * pt
        font.family: "Roboto"
        font.weight: Font.Normal
    }

    Button {
        id: doneButton
        height: 44 * pt
        width: 130 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pendingText.bottom
        anchors.topMargin: 110 * pt
        hoverEnabled: true

        Text {
            id: doneButtonText
            text: qsTr("Done")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pointSize: 18 * pt
            horizontalAlignment: Text.AlignLeft
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            color: doneButton.hovered ? "#737880" : "#A2A4A7"
            border.width: 1 * pt
            border.color: "#989898"
        }
    }
}
