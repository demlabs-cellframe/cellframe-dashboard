import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Rectangle {

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "#F2F2F4"

        DapUiQmlWidgetStatusBarComboBoxWallet {
            id: comboboxWallet
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            listToken: comboboxToken
        }

        DapUiQmlWidgetStatusBarComboBoxToken {
            id: comboboxToken
            anchors.top: parent.top
            anchors.left: comboboxWallet.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            fieldBalance: fieldWalletBalance
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

        DapUiQmlScreenDialogAddWallet
        {
            id: dialogAddWallet

        }

        DapUiQmlWidgetStatusBarButton {
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
