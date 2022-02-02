import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Send " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
    background: Rectangle {color: currTheme.backgroundMainScreen }


    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium28
            color: currTheme.textColor
            text: qsTr("Placed to mempool")
            wrapMode: Text.WordWrap
        }
        Item {
            Layout.fillHeight: true
        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 132 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Done")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                walletNameLabel.visible = true
                window.createWallet(newWalletName);
                mainStackView.clearAll()
            }

        }


        Item {
            Layout.fillHeight: true
        }

    }


}
