import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Send " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
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
//                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Network: ")
            }

            Text {

                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: qsTr(walletModel.get(currentWallet).networks.get(currentNetwork).name)
            }
        }

        RowLayout
        {
            Layout.topMargin: 12 * pt
//            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Text {
                color: currTheme.textColor
//                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                font.family: "Quicksand"
                font.pixelSize: 16 * pt
                font.bold: true
                text: qsTr("Amount: ")
            }

            Text {

                color: currTheme.textColor
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                text: qsTr( sendAmount + " " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
            }
        }

        Text {
            Layout.topMargin: 30
            id: warningText
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
            color: "#B3FF00"

            text: qsTr("Enter a valid wallet address.")
            wrapMode: Text.WordWrap
            visible: false
        }

        TextField {
            Layout.topMargin: 30
            id: addressText
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
//            width: parent.width

            implicitWidth: parent.width* 0.95

            placeholderText: qsTr("Enter a wallet address")
            color: "#ffffff"
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14

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
            Layout.topMargin: 5
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            DapButton
            {
                implicitWidth: 50 * pt
                implicitHeight: 20 * pt
                radius: 5 * pt

                textButton: qsTr("Paste")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    addressText.text = clipboard.getText()
                }

            }

        }

        RowLayout
        {
            Layout.topMargin: 30
            Layout.fillWidth: true
            spacing: 17 * pt

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Back")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
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

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                colorTextButton: "#FFFFFF"
                onClicked:
                {
                    if (addressText.text.length != 104)
                    {
                        warningText.visible = true
                    }
                    else
                    {
                        warningText.visible = false
                        sendAddress = addressText.text

                        mainStackView.push("qrc:/mobile/Wallet/Payment/TransactionOverview.qml")
                    }

                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}
