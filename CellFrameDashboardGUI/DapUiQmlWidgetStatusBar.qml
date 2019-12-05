import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
//    property alias addWalletPressed: statusBarAddWalletButton.pressed
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

        DapUiQmlWidgetStatusBarButton {
            id: statusBarAddWalletButton
            width: 130 * pt
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            onClicked: {
                rightPanel.header.push("DapUiQmlScreenDialogAddWalletHeader.qml", {"rightPanel": rightPanel});
                rightPanel.content.push("DapUiQmlScreenDialogAddWallet.qml", {"rightPanel": rightPanel});
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
