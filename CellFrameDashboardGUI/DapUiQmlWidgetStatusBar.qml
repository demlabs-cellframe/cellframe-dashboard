import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Rectangle {

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "transparent"

        Row {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: buttonAddWallet.left
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

        DapUiQmlScreenDialogAddWallet
        {
            id: dialogAddWallet
        }

        DapUiQmlWidgetStatusBarButton {
            id: buttonAddWallet
            width: 130 * pt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            onClicked: addWallet()
            onAddWallet: dialogAddWallet.show()
        }
    }
}
