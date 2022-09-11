import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("Receive " + dapModelWallets.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
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
            font: mainFont.dapFont.medium16
            color: "#ffffff"

            text: qsTr("Your wallet address is")
        }

        Text {
            id:addrText
            Layout.topMargin: 20 
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.regular16
            color: "#ffffff"

            text: qsTr(dapModelWallets.get(currentWallet).networks.get(currentNetwork).address)
            wrapMode: Text.Wrap
        }


        DapButton
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 78 

            implicitWidth: 132 
            implicitHeight: 36 
            radius: currTheme.radiusButton

            textButton: qsTr("Copy")

            fontButton: mainFont.dapFont.medium14
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
