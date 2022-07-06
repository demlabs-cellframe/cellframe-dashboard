import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "../controls" as Controls
import "qrc:/widgets"

Controls.DapTopPanel
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
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
            Layout.alignment: Qt.AlignVCenter
        }
        Label
        {
            id: textNameWallet
            text: fakeWallet.get(fakeWallet.count - 1).name
            Layout.alignment: Qt.AlignVCenter

            font: mainFont.dapFont.regular16
            color: currTheme.textColor
        }

        // Static token text "Token: "
        Label
        {
            id: headerWalletToken
            Layout.leftMargin: 40
            text: "Token: "
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
        }

        DapComboBox{
            id: tokenComboBox

            property var currentBalance
//            width: 95
            Layout.minimumWidth: 120
            Layout.maximumWidth: 120
            model: fakeWallet.get(fakeWallet.count - 1).tokens
            font: mainFont.dapFont.regular16

            Component.onCompleted: {currentIndex = 0; updateBalance()}

            onCurrentIndexChanged: updateBalance()

            Connections{
                target: stockTab
                onFakeWalletChanged: tokenComboBox.updateBalance()
            }

            function updateBalance(){
                tokenComboBox.currentBalance = tokenComboBox.getModelData(tokenComboBox.currentIndex,"balance_without_zeros")
            }


            background:
            Item
            {
                anchors.fill: parent

                Rectangle
                {
                    id: backGrnd
                    border.width: 0
                    anchors.fill: parent

                    color: currTheme.backgroundMainScreen
                }

                DropShadow
                {
                    anchors.fill: backGrnd
                    horizontalOffset: currTheme.hOffset
                    verticalOffset: currTheme.vOffset
                    radius: currTheme.radiusShadow
                    color: currTheme.shadowColor
                    source: backGrnd
                    samples: 10
                    cached: true
                    visible: tokenComboBox.popup.visible
                }

                InnerShadow {
                    anchors.fill: backGrnd
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 1
                    samples: 10
                    cached: true
                    color: "#524D64"
                    source: backGrnd
                    spread: 0
                    visible: tokenComboBox.popup.visible
                }
            }
        }

        // Static wallet balance text "Wallet balance"
        Label
        {
            id: headerWalletBalance
            Layout.leftMargin: 40
            text: qsTr("Token balance: ")
            font: mainFont.dapFont.regular14
            color: currTheme.textColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Dynamic wallet balance text
        Text
        {
            id: textWalletBalance
//            text: "$ 3 050 745.3453289 USD"
            text: tokenComboBox.currentBalance

            font: mainFont.dapFont.regular16
            color: currTheme.textColor
        }
    }

    function setBackToStockVisible(visible)
    {
        backToStock.visible = visible
    }
}
