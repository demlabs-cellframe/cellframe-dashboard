import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Send " + _dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
    background: Rectangle {color: currTheme.backgroundMainScreen }

    QMLClipboard{
        id: clipboard
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 0

//        Item {
//            Layout.fillHeight: true
//        }

        RowLayout
        {
            Layout.topMargin: 30
//            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Text {
                color: currTheme.textColor
//                font: mainFont.dapFont.bold14
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Network: ")
            }

            Text {

                color: currTheme.textColor
                font: mainFont.dapFont.regular16
                text: qsTr(_dapModelWallets.get(currentWallet).networks.get(currentNetwork).name)
            }
        }

        Text {
            Layout.topMargin: 30
            id: warningText
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: mainFont.dapFont.regular14
            color: "#B3FF00"

            text: qsTr("Not enough available tokens. Enter a lower value.")
            wrapMode: Text.WordWrap
            visible: false
        }

        TextField {
            id: textAmount
            Layout.topMargin: 30
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            width: parent.width

            placeholderText: "0.0"
            validator: RegExpValidator { regExp: /[0-9]+\.?[0-9]{0,9}/ }
            color: "#ffffff"
            font: mainFont.dapFont.dapFontQuicksandMedium36

            background: Rectangle{color:"transparent"}
        }

        Rectangle
        {
            Layout.topMargin: 5
            Layout.fillWidth: true
            height: 1
            color: "#6B6979"
        }

        RowLayout
        {
            Layout.topMargin: 60
            Layout.fillWidth: true
            spacing: 17 * pt

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Back")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    mainStackView.pop()
                }

            }

            DapButton
            {
                id: next
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Next")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    var balance = _dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).balance_without_zeros

                    print("balance",
                          balance)
                    print("textAmount",
                          textAmount.text)

                    if (textAmount.text == "")
                    {
                        warningText.text = "Zero value."
                        warningText.visible = true
                    }
                    else
                    if (balance < textAmount.text)
                    {
                        warningText.text =
                            qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value.").
                            arg(balance)
                        warningText.visible = true
                    }
                    else
                    {
                        sendAmount = textAmount.text

                        print("sendAmount", sendAmount)

                        warningText.visible = false
                        mainStackView.push("TokenAddress.qml")
                    }

                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}