import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    property alias pressedNextButton: nextButton.pressed
    property bool isQRCodeCopied: saveQrCodeButton.checked

    id: recoveryQrMenu
    color: "#edeff2"

    Rectangle {
        id: qrCodeTextArea
        height: 30 * pt
        color: "#757184"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: qrCodeText
            color: "#ffffff"
            text: qsTr("QR Code")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8 * pt
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            anchors.left: parent.left
            anchors.leftMargin: 16 * pt
            font.pointSize: 12 * pt
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: saveQrCodeDescription
        color: "#edeff2"
        height: 42 * pt
        anchors.top: qrCodeTextArea.bottom
        anchors.topMargin: 24 * pt
        anchors.left: qrCodeTextArea.left
        anchors.right: qrCodeTextArea.right
        anchors.leftMargin: 1 * pt
        anchors.rightMargin: 1 * pt

        Text {
            anchors.fill: parent
            text: qsTr("Keep these QR-code in a safe place. They will be\nrequired to restore your wallet in case of loss of\naccess to it")
            font.pointSize: 14 * pt
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#FF0300"

            font {
                family: "Roboto"
                styleName: "Normal"
                weight: Font.Normal
            }
        }
    }

    Rectangle {
        id: qrCodeImageArea
        height: 200 * pt
        width: 200 * pt
        anchors.top: saveQrCodeDescription.bottom
        anchors.topMargin: 24 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#EDEFF2"
        border.width: 1 * pt
        border.color: "#C7C6CE"

        Image {
            id: qrCodeImage
            width: parent.height
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            source: "Resources/QRCode.png"
        }
    }

    Rectangle {
        id: notifyQrCodeSavedArea
        height: 100 * pt
        color: "#EDEFF2"
        anchors.top: qrCodeImageArea.bottom
        anchors.topMargin: 24 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 1 * pt

        Text {
            id: notifyText
            anchors.centerIn: parent
            text: qsTr("")
            color: "#6F9F00"
            font.pointSize: 14 * pt
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout {
        id: actionButtons
        height: 44 * pt
        anchors.leftMargin: 1 * pt
        spacing: 60 * pt
        anchors.top: notifyQrCodeSavedArea.bottom
        anchors.topMargin: 24 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        Layout.leftMargin: 26 * pt
        Layout.columnSpan: 2

        Button {
            id: nextButton
            height: 44 * pt
            width: 130 * pt
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Text {
                id: nextButtonText
                text: qsTr("Create")
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
                color: "#3E3853"
            }
        }

        Button {
            id: saveQrCodeButton
            height: 44 * pt
            width: 130 * pt
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Text {
                id: saveQrCodeButtonText
                text: qsTr("Save")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: saveQrCodeButton.checked ? "#3E3853" : "#FFFFFF"
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pointSize: 18 * pt
                horizontalAlignment: Text.AlignLeft
            }

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: saveQrCodeButton.checked ? "#EDEFF2" : "#3E3853"
                border.color: "#3E3853"
                border.width: 1 * pt
            }

            onClicked: notifyText.text = qsTr(
                           "QR-code saved. Keep them in a\nsafe place before proceeding to the next step.")
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

