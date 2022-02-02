import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Receive " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
    background: Rectangle {color: currTheme.backgroundMainScreen }

    QMLClipboard{
        id: clipboard
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 50
        width: parent.width
        spacing: 0

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            color: "#ffffff"

            text: qsTr("Your wallet address is")
        }

        Text {
            id:addrText
            Layout.topMargin: 20 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
            color: "#ffffff"

            text: qsTr(walletModel.get(currentWallet).networks.get(currentNetwork).address)
            wrapMode: Text.Wrap
        }


        DapButton
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 78 * pt

            implicitWidth: 132 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Copy")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                clipboard.setText(addrText.text)
                mainStackView.clearAll()
            }
        }
        Item {
            Layout.fillHeight: true
        }

    }
}
