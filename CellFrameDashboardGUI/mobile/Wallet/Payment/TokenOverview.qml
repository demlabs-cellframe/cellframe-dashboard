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
        anchors.topMargin: 30 * pt
        anchors.margins: 17 * pt
        width: parent.width
        spacing: 8 * pt

//        Item {
//            Layout.fillHeight: true
//        }

        RowLayout
        {
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                text: qsTr(walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                text: qsTr(walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).balance.toString())
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
            Layout.topMargin: 12 * pt
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                text: qsTr("Max Supply")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
            Layout.topMargin: 12 * pt
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                text: qsTr("Holders")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
            Layout.topMargin: 12 * pt
            Text {
                Layout.alignment: Qt.AlignLeft
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                text: qsTr("Website")
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                Layout.alignment: Qt.AlignRight
                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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
            Layout.topMargin: 30 * pt
            spacing: 17 * pt

            DapButton
            {
                Layout.topMargin: 14 * pt

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Receive")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    mainStackView.push("qrc:/mobile/Wallet/Payment/ReceiveToken.qml")
                }
            }

            DapButton
            {
                Layout.topMargin: 14 * pt

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Send")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    sendToken = walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name
                    mainStackView.push("qrc:/mobile/Wallet/Payment/TokenAmount.qml")
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }

}
