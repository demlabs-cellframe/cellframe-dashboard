import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Token overview")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 30 
        anchors.margins: 17 
        width: parent.width
        spacing: 8 

//        Item {
//            Layout.fillHeight: true
//        }

        RowLayout
        {
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: mainFont.dapFont.bold14
                text: qsTr(dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular14
                text: qsTr(dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).balance_without_zeros.toString())
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#292929"
        }

        RowLayout
        {
            Layout.topMargin: 12 
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: mainFont.dapFont.bold14
                text: qsTr("Max Supply")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular14
                text: qsTr("994445789076.000654")
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#292929"
        }

        RowLayout
        {
            Layout.topMargin: 12 
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: mainFont.dapFont.bold14
                text: qsTr("Holders")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular14
                text: qsTr("546654")
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#292929"
        }

        RowLayout
        {
            Layout.topMargin: 12 
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: mainFont.dapFont.bold14
                text: qsTr("Website")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: mainFont.dapFont.regular14
                text: qsTr("https://cellframe.net/")
            }
        }
        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#292929"
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30 
            spacing: 17 

            DapButton
            {
                Layout.topMargin: 14 

                implicitWidth: 132 
                implicitHeight: 36 
                radius: currTheme.radiusButton

                textButton: qsTr("Receive")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    mainStackView.push("ReceiveToken.qml")
                }
            }

            DapButton
            {
                Layout.topMargin: 14 

                implicitWidth: 132 
                implicitHeight: 36 
                radius: currTheme.radiusButton

                textButton: qsTr("Send")

                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    sendToken = dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name
                    mainStackView.push("TokenAmount.qml")
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }

}
