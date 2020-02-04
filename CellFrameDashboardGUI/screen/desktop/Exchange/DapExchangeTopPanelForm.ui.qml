import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractTopPanelForm
{
    anchors.fill: parent

    // Static text "Wallet"
    Label
    {
        id: textHeaderWallet
        text: qsTr("Wallet")
        anchors.left: parent.left
        anchors.leftMargin: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Roboto"
        font.pixelSize: 12 * pt
        color: "#ACAAB5"
    }

    // Wallet selection combo box
    Rectangle
    {
        id: frameComboBox

        anchors.left: textHeaderWallet.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 30 * pt
        width: 148 * pt
        color: "transparent"

        DapComboBox
        {
            id: comboboxWallet
            //model: modelWallets
            comboBoxTextRole: ["text"]
            indicatorImageNormal: "qrc:/res/icons/ic_arrow_drop_down.png"
            indicatorImageActive: "qrc:/res/icons/ic_arrow_drop_up.png"
            sidePaddingNormal: 0 * pt
            sidePaddingActive: 16 * pt
            normalColorText: "#070023"
            hilightColorText: "#FFFFFF"
            normalColorTopText: "#FFFFFF"
            hilightColorTopText: "#070023"
            hilightColor: "#330F54"
            normalTopColor: "#070023"
            widthPopupComboBoxNormal: 148 * pt
            widthPopupComboBoxActive: 180 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 44 * pt
            bottomIntervalListElement: 8 * pt
            topEffect: false
            x: popup.visible ? sidePaddingActive * (-1) : sidePaddingNormal
            normalColor: "#FFFFFF"
            hilightTopColor: normalColor
            paddingTopItemDelegate: 8 * pt
            heightListElement: 32 * pt
            intervalListElement: 10 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            indicatorLeftInterval: 8 * pt
            colorTopNormalDropShadow: "#00000000"
            colorDropShadow: "#40ABABAB"
            fontComboBox.pixelSize: 14 * pt
            fontComboBox.family: "Roboto"

        }
    }

    // Static wallet balance text "Wallet balance"
    Label
    {
        id: headerWalletBalance
        text: qsTr("Wallet balance")
        anchors.left: frameComboBox.right
        anchors.leftMargin: 70 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Roboto"
        font.pixelSize: 12 * pt
        color: "#ACAAB5"
    }

    // Dynamic wallet balance text
    Label
    {
        id: textWalletBalance
        text: "$ 3 050 745.3453289 USD"
        anchors.left: headerWalletBalance.right
        anchors.leftMargin: 18 * pt
        anchors.verticalCenter: parent.verticalCenter
        font.family: "Roboto"
        font.pixelSize: 16 * pt
        color: "#FFFFFF"
    }
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
