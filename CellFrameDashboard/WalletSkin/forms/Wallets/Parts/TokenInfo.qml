import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets"
import "../../controls"

DapBottomScreen{
    property var tokenData: selectedToken.get(0)

    heightForm: 372
    header.text: tokenData.tokenName

    dataItem:
    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 16
        anchors.bottomMargin: 0
        spacing: 0

        Text
        {
            Layout.topMargin: 4
            text: qsTr("Balance")
            font: mainFont.dapFont.medium14
            color: currTheme.gray
        }
        DapBigText
        {
            Layout.topMargin: 8
            Layout.fillWidth: true
            height: 20
            textColor: currTheme.white
            horizontalAlign: Qt.AlignLeft
            verticalAlign: Qt.AlignVCenter
            fullText: tokenData.value + " " + tokenData.tokenName
            textFont: mainFont.dapFont.medium16
            width: 343
        }

        Text
        {
            Layout.topMargin: 20
            text: qsTr("Wallet address")
            font: mainFont.dapFont.medium14
            color: currTheme.gray
        }
        Text
        {
            id: addressWallet
            Layout.topMargin: 8
            Layout.fillWidth: true
            Layout.minimumHeight: 95
//            width: 343
//            height: 20
            text:  walletModule.currentAddress
            font: mainFont.dapFont.medium16
            color: currTheme.white
            wrapMode: Text.WrapAnywhere
        }

        RowLayout{
            Layout.topMargin: 40
            Layout.fillWidth: true
            Layout.leftMargin: 47
            Layout.rightMargin: 47
            spacing: 17

            DapButton{
                Layout.fillWidth: true
                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Copy address")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    clipboard.setText(addressWallet.text)
                    dapMainWindow.infoItem.showInfo(
                                0,0,
                                qsTr("Address copied"),
                                "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/check_icon.png")
//                    dialog.close()
//                    signalAccept(true)
                }

            }

            DapButton{
                Layout.fillWidth: true
                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Send")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    dapBottomPopup.push("qrc:/walletSkin/forms/Wallets/Parts/TokenSend.qml")
//                    dialog.close()
//                    signalAccept(true)
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
