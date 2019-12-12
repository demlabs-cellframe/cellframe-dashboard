import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import "../../"

Rectangle {
    height:60 * pt
    anchors{
        top: parent.top
        left: parent.left
        right: parent.right
    }
    color: "transparent"
        Row {
            anchors.fill: parent
            Label {
                id:labelWaletStatusBar
                text: qsTr("Wallet")
                anchors.left: parent.left
                anchors.leftMargin: 48 * pt
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
                color: "#ACAAB5"
            }


            Rectangle{
                id:combBoxStatusBar
                anchors.left:labelWaletStatusBar.right
                anchors.leftMargin:30 * pt
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width:148 * pt
                color: "transparent"
                DapComboBox {
                    id: comboboxWallet
                    //    property Label fieldBalance: Label {}
                    //    model: dapWalletModel.wallets
                    //This is a temporary model for checking the result.
                    model:ListModel{
                        id:сonversionList
                        ListElement{text:"all wallets"}
                        ListElement{text:"Money for children"}
                        ListElement{text:"Money for education"}
                        ListElement{text:"Money for medicine"}
                    }
                    indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down.png"
                    indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
                    sidePaddingNormal:0 * pt
                    sidePaddingActive:16 * pt
                    topIndentActive:10 * pt
                    normalColorText:"#070023"
                    hilightColorText:"#FFFFFF"
                    normalColorTopText:"#FFFFFF"
                    hilightColorTopText:"#070023"
                    hilightColor: "#330F54"
                    normalTopColor: "#070023"
                    fontSizeComboBox: 14*px
                    widthPopupComboBoxNormal:148 * pt
                    widthPopupComboBoxActive:180 * pt
                    heightComboBoxNormal:24 * pt
                    heightComboBoxActive:44 * pt
                    bottomIntervalListElement:8 * pt
                    topEffect:false
                    x:popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
                }
            }
            Label {
                id: titleWalletBalance
                anchors.left: combBoxStatusBar.right
                anchors.leftMargin: 70 * pt
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Wallet balance:")
                font.family: fontRobotoRegular.name
                font.pixelSize: 12 * pt
                color: "#ACAAB5"
            }

            Label {
                id: fieldWalletBalance
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: titleWalletBalance.right
                anchors.leftMargin: 18 * pt
                verticalAlignment: Qt.AlignVCenter
                font.family: fontRobotoRegular.name
                font.pixelSize: 16 * pt
                color: "#FFFFFF"
                //This is a temporary model for checking the result.
                text:"$ 3 050 745.3453289 USD"
                //  text: dapChainConvertor.toConvertCurrency(
                //            dapWalletModel.walletBalance(comboboxWallet.currentText))
            }
        }

        DapUiQmlWidgetStatusBarButtonForm {
            id: statusBarAddWalletButton
            width: 120 * pt
            height: 36 * pt
            name: qsTr("New wallet")
            fontHeight: 14 * pt
            backgroundColor: hovered ? "#D51F5D" : "#070023"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10 * pt
            anchors.rightMargin: 20 * pt
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10 * pt

            onClicked: {
                rightPanel.header.push("qrc:/screen/LastAction/DapUiQmlScreenDialogAddWalletHeader.qml", {"rightPanel": rightPanel});
                rightPanel.content.push("qrc:/screen/LastAction/DapUiQmlScreenDialogAddWallet.qml", {"rightPanel": rightPanel});
                statusBarAddWalletButton.backgroundColor = "#D51F5D"
            }

            Connections {
                target: rightPanel.header.currentItem
                onPressedCloseAddWalletChanged: statusBarAddWalletButton.backgroundColor = "#070023"
            }

        }

    }


