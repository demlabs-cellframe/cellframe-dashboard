import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1

Rectangle {
    property alias pressedBackButton: mouseAreaBackButton.pressed
    property alias pressedNextButtonForCreateWallet: nextButton.pressed

    id: recoveryQrMenu
    width: 400
    height: 640
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#edeff2"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    Rectangle {
        id: newWalletArea
        height: 36
        color: "#edeff2"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: newWalletText
            text: qsTr("New wallet")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: backButton.right
            anchors.leftMargin: 12
            font.pointSize: 12
        }

        Button {
            id: backButton
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: newNameArea.left
            anchors.horizontalCenter: newNameArea.Center

            MouseArea {
                id: mouseAreaBackButton
                anchors.fill: parent
                hoverEnabled: true
            }

            background: Image {
                id: imageButton
                source: mouseAreaBackButton.containsMouse ? "qrc:/Resources/Icons/back_icon_hover.png" : "qrc:/Resources/Icons/back_icon.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    Rectangle {
        id: qrCodeTextArea
        height: 30
        color: "#757184"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: newWalletArea.bottom

        Text {
            id: qrCodeText
            color: "#ffffff"
            text: qsTr("QR Code")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 16
            font.pointSize: 10
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: saveQrCodeDescription
        color: "#edeff2"
        height: 42
        anchors.top: qrCodeTextArea.bottom
        anchors.topMargin: 24
        anchors.left: qrCodeTextArea.left
        anchors.right: qrCodeTextArea.right
        anchors.leftMargin: 1 * pt
        anchors.rightMargin: 1 * pt

        Text {
            anchors.fill: parent
            text: qsTr("Keep these QR-code in a safe place. They will be\nrequired to restore your wallet in case of loss of\naccess to it")
            font.pointSize: 10
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
        height: 200
        anchors.top: saveQrCodeDescription.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#EDEFF2"
        anchors.leftMargin: 1

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
        height: 100
        anchors.top: qrCodeImageArea.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#EDEFF2"
        anchors.leftMargin: 1

        Text {
            id: notifyText
            anchors.centerIn: parent
            text: qsTr("")
            color: "#6F9F00"
            font.pointSize: 14
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    RowLayout {
        id: actionButtons
        height: 44
        anchors.leftMargin: 1
        spacing: 60
        anchors.top: notifyQrCodeSavedArea.bottom
        anchors.topMargin: 24
        anchors.left: parent.left
        anchors.right: parent.right
        Layout.leftMargin: 26
        Layout.columnSpan: 2

        Button {
            id: nextButton
            height: 44
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            width: 130

            Text {
                id: nextButtonText
                text: qsTr("Next")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "#ffffff"
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pointSize: 16
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
            height: 44
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            width: 130
            checkable: true

            Text {
                id: saveQrCodeButtonText
                text: qsTr("Save")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: saveQrCodeButton.checked ? "#3E3853" : "#FFFFFF"
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pointSize: 16
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
