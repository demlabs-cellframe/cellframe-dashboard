import QtQuick 2.12
import QtQuick.Controls 2.2
import CellFrameDashboard 1.0

Rectangle {
    property alias translatedText: translatedAmountToken.text
    property alias amountText: inputAmount
    property alias pressedSendButton: mouseAreaSendButton.pressed

    id: newPayment
    width: 640
    height: 800
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

    Rectangle {
        id: newPaymentTextArea
        height: 56
        color: "#FFFFFF"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: newPaymentText
            text: qsTr("New payment")
            font.pointSize: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 13
            anchors.top: parent.top
            anchors.topMargin: 13
            anchors.left: buttonCloseNewPayment.right
            anchors.leftMargin: 12
            color: "#505559"
        }

        Button {
            id: buttonCloseNewPayment
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.left: newPaymentTextArea.left
            anchors.horizontalCenter: newPaymentTextArea.Center
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
    }

    Rectangle {
        id: titleFromTextArea
        height: 30
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: newPaymentTextArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleFromText
            color: "#505559"
            text: qsTr("From")
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: chooseCurrencyTypeArea
        height: 150
        color: "#FFFFFF"
        anchors.leftMargin: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleFromTextArea.bottom

        DapUiQmlWidgetSignatureTypeComboBox {
            id: comboBoxChooseCurrencyType
            height: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 26
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 34
                rightMargin: 36
            }

            model: ListModel {
                id: currencyType
                ListElement {
                    signatureName: "Kelvin"
                }
                ListElement {
                    signatureName: "Token1"
                }
                ListElement {
                    signatureName: "Token2"
                }
                ListElement {
                    signatureName: "New Gold"
                }
            }

            ToolSeparator {
                id: currencySeparator
                anchors.top: comboBoxChooseCurrencyType.bottom
                anchors.topMargin: 20 * pt
                anchors.left: comboBoxChooseCurrencyType.left
                anchors.right: comboBoxChooseCurrencyType.right
                orientation: Qt.Horizontal
            }

            Text {
                id: walletName
                height: 25
                color: "#B5B5B5"
                text: qsTr("brz89EWFKlkmfwk392i32300503493")
                font.family: "Roboto"
                font.pointSize: 14
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.top: currencySeparator.bottom
                anchors.topMargin: 15
                anchors.left: currencySeparator.left
                anchors.right: currencySeparator.right
            }
        }
    }

    Rectangle {
        id: titleAmmountTextArea
        height: 30
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: chooseCurrencyTypeArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleAmmountText
            color: "#505559"
            text: qsTr("Ammount")
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: inputAmmountArea
        height: 100
        anchors.leftMargin: 1
        anchors.top: titleAmmountTextArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        TextInput {
            id: inputAmount
            text: qsTr("0")
            font.weight: Font.Normal
            font.pointSize: 18
            font.family: "Roboto"
            anchors.top: parent.top
            anchors.topMargin: 22
            anchors.left: parent.left
            anchors.leftMargin: 34
            anchors.right: parent.right
            anchors.rightMargin: 36

            ToolSeparator {
                id: amountSeparator
                anchors.top: inputAmount.bottom
                anchors.topMargin: 20 * pt
                anchors.left: inputAmount.left
                anchors.right: inputAmount.right
                orientation: Qt.Horizontal
            }

            Text {
                id: translatedAmountToken
                text: qsTr("0")
                leftPadding: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                color: "#B5B5B5"
                anchors.top: amountSeparator.bottom
                anchors.topMargin: 4
                anchors.left: amountSeparator.left
                anchors.right: amountSeparator.right
                font.pointSize: 14
            }
        }
    }

    Rectangle {
        id: titleToRecipientTextArea
        height: 30
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: inputAmmountArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleToRecipientText
            color: "#505559"
            text: qsTr("To")
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: recipientWalletArea
        height: 100
        anchors.top: titleToRecipientTextArea.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.right: parent.right

        TextInput {
            id: recipientWalletName
            text: "Recipient wallet"
            font.pointSize: 17
            color: "#F1F2F2"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            anchors.top: parent
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 34
            anchors.right: parent.right
            anchors.rightMargin: 32

            onTextChanged: recipientWalletName.color = "#505559"
            onActiveFocusChanged: recipientWalletName.text = ""
        }

        ToolSeparator {
            id: recipientWalletSeparator
            anchors.top: recipientWalletName.bottom
            anchors.topMargin: 18 * pt
            anchors.left: recipientWalletName.left
            anchors.right: recipientWalletName.right
            orientation: Qt.Horizontal
        }

        Button {
            id: sendButton
            height: 44
            width: 130

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            anchors.top: recipientWalletSeparator.bottom
            anchors.topMargin: 58

            MouseArea {
                id: mouseAreaSendButton
                anchors.fill: parent
                hoverEnabled: true
            }

            Text {
                id: sendButtonText
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
                color: mouseAreaSendButton.containsMouse ? "#737880" : "#A2A4A7"
                border.width: 1 * pt
                border.color: "#989898"
            }
        }
    }
}

/*##^##
Designer {
    D{i:16;anchors_x:131;anchors_y:36}
}
##^##*/

