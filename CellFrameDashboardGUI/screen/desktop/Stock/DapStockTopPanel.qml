//import QtQuick 2.4
//import QtQuick.Controls 2.0
//import QtQuick.Layouts 1.3
//import "qrc:/widgets"
//import "../../"
//import "../SettingsWallet.js" as SettingsWallet

import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../controls"

DapTopPanel
{
    anchors.leftMargin: 4
//    radius: currTheme.radiusRectangle
//    color: currTheme.backgroundPanel

    RowLayout
    {
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        spacing: 18

        Label
        {
            id: backToStock
            Layout.rightMargin: 40
            font: mainFont.dapFont.regular16
            color: currTheme.textColor
            text: qsTr(" <  Stock")
            visible: false

            MouseArea
            {
                anchors.fill: parent

                onClicked:
                {
                    stockScreen.changeMainPage(
                                "parts/StockHome.qml")
                    backToStock.visible = false
                }
            }
        }

        // Static text "Wallet"
        Label
        {
            id: textHeaderWallet
            text: qsTr("Wallet: ")
            font: mainFont.dapFont.regular12
            color: currTheme.textColor
        }
        Label
        {
            id: textNameWallet
            text: dapModelWallets.get(logicMainApp.currentIndex).name
            font: mainFont.dapFont.regular16
            color: currTheme.textColor
        }

        // Static wallet balance text "Wallet balance"
        Label
        {
            id: headerWalletBalance
            Layout.leftMargin: 40
            text: qsTr("Token balance: ")
            font: mainFont.dapFont.regular12
            color: currTheme.textColor
        }

        // Dynamic wallet balance text
        Label
        {
            id: textWalletBalance
//            text: "$ 3 050 745.3453289 USD"
            text: exchangeTokenModel.count ? exchangeTokenModel.get(tokenComboBox.currentIndex).balance_without_zeros : "-------"
            font: mainFont.dapFont.regular16
            color: currTheme.textColor
        }

        // Static token text "Token: "
        Label
        {
            id: textWalletToken
            Layout.leftMargin: 40
            text: "Token: "
            font: mainFont.dapFont.regular12
            color: currTheme.textColor
        }
    }

    function setBackToStockVisible(visible)
    {
        backToStock.visible = visible
    }
}
