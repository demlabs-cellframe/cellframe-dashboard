import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Wallet")
    background: Rectangle {color: currTheme.mainBackground }
    hoverEnabled: true

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        DapImageRender {
            Layout.topMargin: 80
            Layout.alignment: Qt.AlignHCenter
            sourceSize.width: 134
            sourceSize.height: 214
//            mipmap: true
            source: "qrc:/walletSkin/Resources/" + pathTheme + "/Illustratons/Wallet.svg"
        }
        Text {
            Layout.topMargin: 47
            Layout.leftMargin: 27
            Layout.rightMargin: 27
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("You don’t have any wallets. Create a new wallet or import an existing one.")
            font: mainFont.dapFont.medium16
            color: currTheme.gray
            wrapMode: Text.WordWrap
        }

        DapButton
        {
            Layout.topMargin: 32
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 165
            implicitHeight: 36
            radius: currTheme.radiusButton

            textButton: qsTr("Get started")

            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: currTheme.white
            onClicked:
            {
                logicMainApp.restoreWalletMode = false
                dapBottomPopup.show("qrc:/walletSkin/forms/Settings/BottomForms/DapCreateWallet.qml")
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
