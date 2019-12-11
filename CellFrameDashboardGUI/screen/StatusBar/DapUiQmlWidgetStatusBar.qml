import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "transparent"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            spacing: 10 * pt

            Label {
                text: qsTr("Wallet")
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
                color: "#A7A7A7"
            }

            DapUiQmlWidgetStatusBarComboBoxWallet {
                id: comboboxWallet
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                fieldBalance: fieldWalletBalance
            }

            Label {
                id: titleWalletBalance
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Wallet balance:")
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
                color: "#A7A7A7"
            }

            Label {
                id: fieldWalletBalance
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                font.family: fontRobotoRegular.name
                font.pixelSize: 16 * pt
                color: "#FFFFFF"
                text: dapChainConvertor.toConvertCurrency(
                          dapWalletModel.walletBalance(comboboxWallet.currentText))
            }
        }

        DapUiQmlWidgetStatusBarButtonForm {
            id: statusBarAddWalletButton
            width: 120 * pt
            height: 36 * pt
            name: qsTr("New wallet")
            fontHeight: 14 * pt
            backgroundColor: "#070023"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            onClicked: {
                rightPanel.header.push("qrc:/screen/LastAction/DapUiQmlScreenDialogAddWalletHeader.qml", {"rightPanel": rightPanel});
                rightPanel.content.push("qrc:/screen/LastAction/DapUiQmlScreenDialogAddWallet.qml", {"rightPanel": rightPanel});
            }
        }
    }
}
