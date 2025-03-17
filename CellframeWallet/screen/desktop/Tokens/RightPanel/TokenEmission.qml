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

DapRectangleLitAndShaded {
    id: root

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

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
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Select certificate")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        Item
        {
            height: 56 
            Layout.fillWidth: true

            DapCustomComboBox {
                id: certificates
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                model: certificatesModel

                mainTextRole: "completeBaseName"
                font: mainFont.dapFont.regular16
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 

            Text {
                color: currTheme.white
                text: qsTr("Emission value")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }


        Item
        {
            Layout.fillWidth: true
            Layout.topMargin: 10
            height: 60

            Rectangle
            {
                anchors.fill: parent
                anchors.leftMargin: 33
                anchors.rightMargin: 33
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                border.width: 1
                radius: 4
                border.color: "#666E7D"
                color: "transparent"

                DapTextField
                {
                    id: textInputAmount
                    anchors.fill: parent
                    placeholderText: "0.0"
                    validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                    font: mainFont.dapFont.regular16
                    horizontalAlignment: Text.AlignRight

                    borderWidth: 1
                    borderRadius: 4
                    placeholderColor: currTheme.white

                    selectByMouse: true
                    DapContextMenu{}
                }
            }
        }

        Rectangle {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            Layout.topMargin: 10
            height: 30

            Text {
                color: currTheme.white
                text: qsTr("Wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }




        Rectangle
        {
            Layout.fillWidth: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            height: 53 
            color: "transparent"

            DapTextField
            {
                id: textInputRecipientWalletAddress
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Paste here")
                validator: RegExpValidator { regExp: /[0-9A-Za-z]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                bottomLineVisible: true
                bottomLineSpacing: 5
                bottomLineLeftRightMargins: 7

                selectByMouse: true
                DapContextMenu{}
            }
        }

        Item
        {
            id: frameBottom
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text
        {
            id: error

            Layout.minimumHeight: 30
            Layout.maximumHeight: 80
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.bottomMargin: 12
            Layout.maximumWidth: 281

            color: "#79FFFA"
            text: ""
            font: mainFont.dapFont.regular14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            visible: false
        }

        DapButton
        {
            implicitHeight: 36
            implicitWidth: 163

            Layout.bottomMargin: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            textButton: qsTr("Emission")
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText:Qt.AlignCenter

            onClicked:{

                var supply = mathWorker.balanceToCoins(detailsModel.get(0).current_supply)

                if (textInputAmount.text === "" ||
                    stringWorker.testAmount("0.0", textInputAmount.text))
                {
                    error.visible = true
                    error.text = qsTr("Zero value.")
                }
                else
                if (!stringWorker.testAmount(supply, textInputAmount.text))
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
                    logicMainApp.requestToService("DapTokenEmissionCommand", stringWorker.toDatoshi(textInputAmount.text),
                                                          textInputRecipientWalletAddress.text,
                                                          dapModelTokens.get(logicTokens.selectNetworkIndex).network,
                                                          dapModelTokens.get(logicTokens.selectNetworkIndex).tokens.get(logicTokens.selectTokenIndex).name,
                                                          certificates.displayText)

                }
            }
        }
    }

    Connections{
        target: dapServiceController
        function onResponseEmissionToken(resultEmission)
        {
            logicTokens.commandResult = resultEmission
            navigator.done()
        }
    }
}



