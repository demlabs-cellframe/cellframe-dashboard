import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import DapTransactionHistory 1.0

Rectangle {

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "#F2F2F4"

        DapUiQmlWidgetStatusBarComboBox {
            id: comboboxWallet
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            model: dapChainWalletsModel
            textRole: "name"


            delegate: ItemDelegate {
                width: parent.width
                contentItem: DapUiQmlWidgetStatusBarContentItem {
                    text: name
                }

                highlighted: parent.highlightedIndex === index
            }

            onCurrentIndexChanged: {
                tokenList.clear();
                for(var i = 0; i < dapChainWalletsModel.get(currentIndex).count; i++)
                    tokenList.append({"tokenName": dapChainWalletsModel.get(currentIndex).tokens[++i]});
                if(tokenList.count)
                    comboboxToken.currentIndex = 0;
            }
        }

        DapUiQmlWidgetStatusBarComboBox {
            id: comboboxToken
            anchors.top: parent.top
            anchors.left: comboboxWallet.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            model: ListModel {id: tokenList}
            textRole: "tokenName"

            delegate: ItemDelegate {
                width: parent.width
                contentItem: DapUiQmlWidgetStatusBarContentItem {
                    text: tokenName
                }

                highlighted: parent.highlightedIndex === index
            }

            onCurrentIndexChanged: {
                if(currentIndex === -1)
                    fieldWalletBalance.text = 0;
                else
                {
                    var money = dapChainWalletsModel.get(comboboxWallet.currentIndex).tokens[currentIndex * 2];
                    fieldWalletBalance.text = dapChainConvertor.toConvertCurrency(money);
                }
            }
        }

        Label {
            id: titleWalletBalance
            anchors.top: parent.top
            anchors.left: comboboxToken.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 40 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            verticalAlignment: Qt.AlignVCenter
            text: "Wallet balance:"
            font.family: "Regular"
            font.pixelSize: 12 * pt
            color: "#A7A7A7"
        }

        Label {
            id: fieldWalletBalance
            anchors.top: parent.top
            anchors.left: titleWalletBalance.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            verticalAlignment: Qt.AlignVCenter
            font.family: "Regular"
            font.pixelSize: 16 * pt
            color: "#797979"
        }

        Button {
            width: 130 * pt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            contentItem: Rectangle {
                anchors.fill: parent
                border.color: "#B5B5B5"
                border.width: 1 * pt
                color: "transparent"

                Text {
                    anchors.fill: parent
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignRight
                    anchors.rightMargin: 20 * pt
                    font.family: "Regular"
                    color: "#505559"
                    text: qsTr("New wallet")
                }

                Image {
                    id: iconNewWallet
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * pt
                    source: "qrc:/Resources/Icons/defaul_icon.png"
                    width: 28 * pt
                    height: 28 * pt
                }
            }
        }
    }
}
