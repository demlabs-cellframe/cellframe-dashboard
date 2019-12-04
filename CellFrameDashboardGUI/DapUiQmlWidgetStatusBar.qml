import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
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

            DapComboBox {
                id: comboboxWallet
                width: 190*pt
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                property Label fieldBalance: Label {}
                model: dapWalletModel.wallets
                ///Эта строка была ранее возможно на что то влияла но сейчас файлы объеденились возможно не нужна.
              //  fieldBalance: fieldWalletBalance

                indicator: Image {
                    id: arrow
                    source: parent.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
                    width: 24 * pt
                    height: 24 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 16 * pt
                }
                contentItem: Text {
                    id: headerText
                    anchors.fill: parent
                    anchors.leftMargin: 12 * pt
                    anchors.rightMargin: 48 * pt
                    anchors.topMargin: 10 * pt
                    text: parent.displayText
                    font.family: fontRobotoRegular.name
                    font.pixelSize: 14 * pt
                    color: parent.popup.visible ? "#332F49" : "#FFFFFF"
                    verticalAlignment: Text.AlignTop
                    elide: Text.ElideRight
                }
                hilightColor: "#332F49"
                fontSizeComboBox: 14*px
                hilightColorText: "#FFFFFF"
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
