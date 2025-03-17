import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets" as Widgets


Controls.DapTopPanel
{
    property alias layout: layout

    property bool isModel: false
    property string statusProtected: ""

    Controls.DapLoadingTopPanel
    {
    }

    RowLayout
    {
        id: layout
        anchors.fill: parent
        spacing: 0

        Text{
            text: qsTr("Wallet:")
            font: mainFont.dapFont.regular14
            color: currTheme.gray
            Layout.leftMargin: 24
            Layout.alignment: Qt.AlignVCenter
            Layout.bottomMargin: 1
        }

        DapWalletComboBox
        {
            id: comboBoxCurrentWallet

            Layout.fillHeight: true
            Layout.topMargin: 9
            Layout.bottomMargin: 10
            Layout.leftMargin: 6
            width: 220
            displayText: walletModule.currentWalletName
            font: mainFont.dapFont.regular14

            model: walletModelList

            enabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
            disabledIcon: "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"

            Component.onCompleted:
            {
                console.log("DapWalletTopPanel onCompleted",
                            "logicMainApp.currentWalletIndex", walletModule.currentWalletIndex)
                setCurrentIndex(walletModule.currentWalletIndex)
            }

            defaultText: qsTr("Wallets")
        }

        Rectangle{
            id: buttonActivate
            Layout.leftMargin: 2
            width: 32
            height: 32
            radius: 4
            color: area.containsMouse ? currTheme.rowHover : currTheme.secondaryBackground

            visible: isModel
            Image{
                anchors.centerIn: parent
                source:
                {
                    if(statusProtected === "")
                    {
                        return "qrc:/Resources/BlackTheme/icons/other/icon_activate_pass.svg"
                    }
                    return statusProtected === "non-Active" ? "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                                                                                         : "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg"
                }
                mipmap: true
            }

            Widgets.DapCustomToolTip{
                contentText: logicWallet.walletStatus === "" ? qsTr("Create password for this wallet") : (logicWallet.walletStatus === "non-Active" ? qsTr("Unlock wallet") : qsTr("Deactivate wallet"))
            }

            MouseArea{
                id: area
                hoverEnabled: true
                anchors.fill: parent

                onClicked: {
                    if(walletModelList.get(walletModule.currentWalletIndex).statusProtected === "")
                    {
                        tryCreatePasswordWalletPopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName, createPasswordWalletPopup, false)
                    }
                    else if(walletModelList.get(walletModule.currentWalletIndex).statusProtected === "non-Active")
                    {
                        walletActivatePopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName, false)
                    }
                    else
                    {
                        walletDeactivatePopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName)
                    }
                }
            }
        }

        Widgets.DapButton
        {
            Layout.leftMargin: 29

            textButton: qsTr("Restore wallet")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            selected: false
            onClicked: navigator.restoreWalletFunc()

            Widgets.DapCustomToolTip{
                contentText: qsTr("Restore wallet")
            }

        }

        Widgets.DapButton
        {
            Layout.leftMargin: 16

            textButton: qsTr("Create new wallet")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter
            selected: false
            onClicked: navigator.createWallet()

            Widgets.DapCustomToolTip{
                contentText: qsTr("Create new wallet")
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Payment button
        Widgets.DapButton
        {
            id: newPaymentButton
            Layout.rightMargin: 24
            enabled: statusProtected !== "non-Active"

            textButton: qsTr("Send")

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            onClicked: {
                walletInfo.name = walletModule.currentWalletName
                dapRightPanel.pop()
                navigator.newPayment()
            }

            Widgets.DapCustomToolTip{
                contentText: qsTr("Sending tokens between your accounts")
            }
        }
    }

    function updateStatusWalletInfo()
    {
        isModel = !walletModelList.count ? false : true
        statusProtected = walletModelList.get(walletModule.currentWalletIndex).statusProtected
        comboBoxCurrentWallet.displayText = walletModule.getCurrentWalletName()
    }
    
    Connections
    {
        target: walletModule

        function onCurrentWalletChanged()
        {
            updateStatusWalletInfo()
        }

        function onWalletsModelChanged()
        {
            updateStatusWalletInfo()
        }

        function onListWalletChanged()
        {
            console.log("DapWalletTopPanel onModelWalletsUpdated",
                        "currentWalletName", walletModule.currentWalletName,
                        "currentWalletIndex", walletModule.currentWalletIndex)

            if(walletModule.currentWalletIndex >= 0)
            {
                 comboBoxCurrentWallet.displayText = walletModule.currentWalletName
                updateStatusWalletInfo()
            }
        }
    }
    
    Component.onCompleted:
    {
        updateStatusWalletInfo()
    }
}
