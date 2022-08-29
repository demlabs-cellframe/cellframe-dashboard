import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.12 as Controls
import QtQml 2.12
import "qrc:/widgets"
import "../parts"
import "../../controls"

Controls.Page {
    id: root

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        width: parent.width
//        height: childrenRect.height

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 21 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/back.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/back_hover.svg"
                onClicked:
                {
//                    logicTokens.unselectToken()
                    dapRightPanel.pop()
//                    navigator.clear()
                }
            }

            Text
            {
                id: textHeader
                text: qsTr("Emission")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Select certificate")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item
        {
            height: 56 * pt
            Layout.fillWidth: true

            DapComboBox {
                id: certificates
                anchors.fill: parent
                anchors.leftMargin: 15 * pt
                anchors.rightMargin: 15 * pt
                model: certificatesModel

                mainTextRole: "completeBaseName"
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Emission value")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Item
        {
            Layout.fillWidth: true
            height: 60 * pt

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 36 * pt
                anchors.rightMargin: 36 * pt
                anchors.topMargin: 16 * pt
                anchors.bottomMargin: 16 * pt
                border.width: 1
                border.color: "#666E7D"
                color: "transparent"

                TextField
                {
                    id: textInputAmount
                    anchors.fill: parent
    //                        placeholderText: "0"
                            placeholderText: "0.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight

                    style:
                        TextFieldStyle
                        {
                            textColor: currTheme.textColor
                            placeholderTextColor: currTheme.textColor
                            background:
                                Rectangle
                                {
                                    border.width: 1
                                    radius: 4 * pt
                                    border.color: currTheme.borderColor
                                    color: currTheme.backgroundElements
                                }
                        }
                }
            }
        }

        Rectangle {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt

            Text {
                color: currTheme.textColor
                text: qsTr("Wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 17 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.leftMargin: 20 * pt
            Layout.rightMargin: 20 * pt
            height: 53 * pt
            color: "transparent"

            TextField
            {
                id: textInputRecipientWalletAddress
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Paste here")
                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.topMargin: 26 * pt
                style:
                    TextFieldStyle
                    {
                        textColor: currTheme.textColor
                        placeholderTextColor: currTheme.placeHolderTextColor

                        background:
                            Rectangle
                            {
                                border.width: 0
                                color: currTheme.backgroundElements
                            }
                    }
            }

            Rectangle
            {
                height: 1 * pt
                width: parent.width - x * 2
                color: currTheme.borderColor
                y: textInputRecipientWalletAddress.y + textInputRecipientWalletAddress.height + 5 * pt
                x: 10 * pt
            }
        }

        Rectangle
        {
            width: 278*pt
            height: 69 * pt
            color: "transparent"
            Layout.topMargin: 43 * pt
            Layout.fillWidth: true

            Text
            {
                id: error
                anchors.fill: parent
                anchors.leftMargin: 37 * pt
                anchors.rightMargin: 36 * pt
                color: "#79FFFA"
                text: qsTr("")
                font: mainFont.dapFont.regular14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                visible: false
            }
        }

    }

    DapButton
    {
        implicitWidth: 165 * pt
        implicitHeight: 36 * pt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24 * pt
        textButton: qsTr("Emission")
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText:Qt.AlignCenter

        onClicked:{

            var supply = dapMath.balanceToCoins(detailsModel.get(0).current_supply)

            if (textInputAmount.text === "" ||
                logicTokens.testAmount("0.0", textInputAmount.text))
            {
                error.visible = true
                error.text = qsTr("Zero value.")
            }
            else
            if (!logicTokens.testAmount(supply, textInputAmount.text))
            {
                error.visible = true
                error.text =
                    qsTr("Not enough available tokens. Maximum value = %1. Enter a lower value. Current value with comission = %2").
                    arg(supply).arg(textInputAmount.text)
            }
            else
            if (textInputRecipientWalletAddress.text.length != 104)
            {
                error.visible = true
                error.text = qsTr("Enter a valid wallet address.")
            }

            else
            {
                error.visible = false
                dapServiceController.requestToService("DapTokenEmissionCommand", logicTokens.toDatoshi(textInputAmount.text),
                                                      textInputRecipientWalletAddress.text,
                                                      dapModelTokens.get(logicTokens.selectNetworkIndex).network,
                                                      dapModelTokens.get(logicTokens.selectNetworkIndex).tokens.get(logicTokens.selectTokenIndex).name,
                                                      certificates.displayText)

            }
        }
    }

    Connections{
        target: dapServiceController
        onResponseEmissionToken:
        {
            logicTokens.commandResult = resultEmission
            navigator.done()
        }
    }
}



