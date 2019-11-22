import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    property alias pressedCloseNewPaymentStatusButton: mouseAreaCloseNewPayment.pressed

    id: newPaymentStatus
    width: 640
    height: 800
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    Button {
        id: buttonCloseNewPaymentStatus
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.topMargin: 13
        anchors.left: parent.left
        anchors.leftMargin: 12

        background: Image {
            source: mouseAreaCloseNewPayment.containsMouse ? "qrc:/Resources/Icons/ic_close_hover.png" : "qrc:/Resources/Icons/ic_close.png"
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            id: mouseAreaCloseNewPayment
            anchors.fill: parent
            hoverEnabled: true
        }
    }

    Text {
        id: mempoolText
        text: qsTr("Placed to mempool")
        color: "#070023"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 236
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 26
        font.family: "Roboto"
        font.styleName: "Normal"
        font.weight: Font.Normal
    }

    Text {
        id: statusText
        text: qsTr("Status")
        color: "#b5b5b5"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mempoolText.bottom
        anchors.topMargin: 56
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 20
        font.family: "Roboto"
        font.styleName: "Normal"
        font.weight: Font.Normal
    }

    Text {
        id: pendingText
        text: qsTr("Pending")
        color: "#070023"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: statusText.bottom
        anchors.topMargin: 16
        horizontalAlignment: Text.AlignLeft
        font.pointSize: 26
        font.family: "Roboto"
        font.styleName: "Normal"
        font.weight: Font.Normal
    }

    Button {
        id: doneButton
        height: 44
        width: 130
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pendingText.bottom
        anchors.topMargin: 110

        MouseArea {
            id: mouseAreaDoneButton
            anchors.fill: parent
            hoverEnabled: true
        }

        Text {
            id: doneButtonText
            text: qsTr("Send")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            font.pointSize: 18
            horizontalAlignment: Text.AlignLeft
        }

        background: Rectangle {
            implicitWidth: parent.width
            implicitHeight: parent.height
            color: mouseAreaDoneButton.containsMouse ? "#737880" : "#A2A4A7"
            border.width: 1 * pt
            border.color: "#989898"
        }
    }
}
