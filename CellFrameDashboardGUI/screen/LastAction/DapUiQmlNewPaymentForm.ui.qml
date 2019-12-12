import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import CellFrameDashboard 1.0
import "../../"
import "../"

DapUiQmlScreen {
    property alias convertedAmmount: convertedAmountToken.text
    property alias amountText: inputAmount
    property alias pressedSendButton: sendButton.pressed
    property alias currencyTypeList: currencyType

    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#FFFFFF"

    Rectangle {
        id: titleFromTextArea
        height: 30 * pt
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: titleFromText
            color: "#505559"
            text: qsTr("From")
            anchors.left: parent.left
            anchors.leftMargin: 18 * pt
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12 * pt
            horizontalAlignment: Text.AlignLeft
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
        }
    }

    Rectangle {
        id: chooseCurrencyTypeArea
        height: 150 * pt
        color: "#FFFFFF"
        anchors.leftMargin: 1 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleFromTextArea.bottom

        DapComboBox {
            id: comboBoxChooseCurrencyType
            height: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 26 * pt
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 34 * pt
                rightMargin: 36 * pt
            }

            indicatorImageNormal: "qrc:/res/icons/icon_arrow_down.png"
            indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"

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
            height: 25 * pt
            color: "#B5B5B5"
            text: qsTr("brz89EWFKlkmfwk392i32300503493")
            font.family: "Roboto"
            font.pointSize: 14 * pt
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.top: currencySeparator.bottom
            anchors.topMargin: 15 * pt
            anchors.left: currencySeparator.left
            anchors.right: currencySeparator.right
        }
    }

    Rectangle {
        id: titleAmmountTextArea
        height: 30 * pt
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.top: chooseCurrencyTypeArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleAmmountText
            color: "#505559"
            text: qsTr("Ammount")
            anchors.left: parent.left
            anchors.leftMargin: 18 * pt
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12 * pt
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: inputAmmountArea
        height: 140 * pt
        anchors.leftMargin: 1 * pt
        anchors.top: titleAmmountTextArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        TextInput {
            id: inputAmount
            anchors.top: parent.top
            anchors.topMargin: 22 * pt
            anchors.left: parent.left
            anchors.leftMargin: 34 * pt
            anchors.right: parent.right
            anchors.rightMargin: 36 * pt
            text: qsTr("0")
            validator: RegExpValidator {
                regExp: /[0-9]+/
            }

            maximumLength: 20

            font.weight: Font.Normal
            font.pointSize: 18 * pt
            font.family: "Roboto"
        }

        Text {
            id: currencyTypeSuffix
            anchors.top: inputAmount.top
            anchors.bottom: inputAmount.bottom
            anchors.right: inputAmount.right
            text: qsTr("KLVN")
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            font.pointSize: 16 * pt
            font.family: "Roboto"
        }

        ToolSeparator {
            id: amountSeparator
            anchors.top: inputAmount.bottom
            anchors.topMargin: 12 * pt
            anchors.left: inputAmount.left
            anchors.right: inputAmount.right
            orientation: Qt.Horizontal
        }

        Text {
            id: convertedAmountToken
            text: qsTr("0")
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            color: "#B5B5B5"
            anchors.top: amountSeparator.bottom
            anchors.topMargin: 22 * pt
            anchors.left: amountSeparator.left
            anchors.right: amountSeparator.right
            font.pointSize: 14 * pt
        }

        Text {
            id: suffixUSD
            anchors.top: convertedAmountToken.top
            anchors.bottom: convertedAmountToken.bottom
            anchors.right: convertedAmountToken.right
            text: qsTr("USD")
            color: "#B5B5B5"
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            font.pointSize: 14 * pt
            font.family: "Roboto"
        }
    }

    Rectangle {
        id: titleToRecipientTextArea
        height: 30
        color: "#DFE3E6"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.top: inputAmmountArea.bottom
        anchors.topMargin: 0

        Text {
            id: titleToRecipientText
            color: "#505559"
            text: qsTr("To")
            anchors.left: parent.left
            anchors.leftMargin: 18 * pt
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 12 * pt
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
        }
    }

    Rectangle {
        id: recipientWalletArea
        height: 100 * pt
        anchors.top: titleToRecipientTextArea.bottom
        anchors.topMargin: 20 * pt
        anchors.left: parent.left
        anchors.leftMargin: 1 * pt
        anchors.right: parent.right

        TextField {
            id: recipientWalletName
            placeholderText: "Recipient wallet"
            placeholderTextColor: "#F1F2F2"
            font.pointSize: 17 * pt
            color: "#505559"
            font.family: "Roboto"
            font.styleName: "Normal"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignLeft
            anchors.top: parent
            anchors.topMargin: 20 * pt
            anchors.left: parent.left
            anchors.leftMargin: 34 * pt
            anchors.right: parent.right
            anchors.rightMargin: 32 * pt
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectCharacters

            background: Rectangle {
                anchors.fill: parent
                color: "#FFFFFF"
            }
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
            height: 44 * pt
            width: 130 * pt
            hoverEnabled: true

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0
            anchors.top: recipientWalletSeparator.bottom
            anchors.topMargin: 58 * pt

            Text {
                id: sendButtonText
                text: qsTr("Send")
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
                color: sendButton.hovered ? "#737880" : "#A2A4A7"
                border.width: 1 * pt
                border.color: "#989898"
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

