import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Wallet protected")
    background: Rectangle {color: currTheme.mainBackground }
    hoverEnabled: true

    onVisibleChanged:
    {
        unlockBtn.enabled = true
    }

    ColumnLayout
    {
        anchors.centerIn: parent
        width: 200
        height: 320
        spacing: 0

        DapImageRender {
            Layout.alignment: Qt.AlignHCenter
            sourceSize.width: 160
            sourceSize.height: 231
            source: "qrc:/walletSkin/Resources/" + pathTheme + "/Illustratons/lock_illustration.svg"
        }

        DapButton
        {
            id: unlockBtn
            Layout.topMargin: 32
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 165
            implicitHeight: 36
            radius: currTheme.radiusButton
            textButton: qsTr("Unlock wallet")
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: currTheme.white
            onClicked:
            {
                var currentWallet = walletModule.getCurrentWalletName()
                if(currentWallet !== "") dapBottomPopup.showActivateWallet(currentWallet, false)
            }
        }

        Item { Layout.fillHeight: true }
    }

    Connections
    {
        target: dapBottomPopup
        function onActivatingSignal(nameWallet, statusRequest){
            if(nameWallet === walletModule.currentWalletName && statusRequest)
            {
                unlockBtn.enabled = false
            }
            else
            {
                unlockBtn.enabled = true
            }
        }
    }
}
