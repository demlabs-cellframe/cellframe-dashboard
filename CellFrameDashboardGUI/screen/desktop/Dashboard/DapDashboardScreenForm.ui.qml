import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    id: dapDashboardScreen
    dapFrame.color: "#FFFFFF"
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

    // Paths to currency emblems
    property string bitCoinImagePath: "qrc:/resources/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/resources/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/resources/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/resources/icons/ic_klvn.png"
    ///@param dapButtonNewPayment Button to create a new payment.
    property alias dapButtonNewPayment: buttonNewPayment
    property alias dapListViewWallet: listViewWallet
    property alias dapNameWalletTitle: titleText
    property alias dapWalletCreateFrame: walletCreateFrame
    property alias dapTitleBlock: titleBlock
    property alias dapAddWalletButton: addWalletButton

    Rectangle
    {
        id: walletCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        Column
        {
            y: 0
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 200 * pt
                width: parent.width
            }
            Image
            {
                id: iconCreateWallet
                y: 0
                source: "../../../resources/icons/illustration-new-wallet.svg"
                sourceSize.height: 315
                sourceSize.width: 499
                width: 499
                height: 315
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 24 * pt
                width: parent.width
            }
            Text
            {
                id: titleTextWalletCreate
                font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
                font.pixelSize: 30 * pt
                color: "#757184"
                text: qsTr("Create a new wallet")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 56 * pt
                width: parent.width
            }
            DapButton
            {
                id: addWalletButton
                implicitWidth: 124 * pt
                implicitHeight: 40 * pt
                textButton: "New wallet"
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#070023"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                dapHorizontalAlignment: Qt.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: Layout.fillHeight
                width: parent.width
            }
        }
    }

    Rectangle
    {
        id: titleBlock
        anchors.top: parent.top
        anchors.topMargin: 20 * pt
        anchors.bottomMargin: 20 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        height: 36 * pt

        RowLayout
        {
            anchors.fill: parent

            Text
            {
                id: titleText
                font.family: dapMainFonts.dapMainFontTheme.dapFontRobotoRegularCustom
                font.pixelSize: 20 * pt
                text: "My first crypto wallet"
                width: 185 * pt
            }

            MouseArea
            {
                id: walletNameEditButton
                width: 16 * pt
                height: 16 * pt
                hoverEnabled: true
                anchors.left: titleText.right
                anchors.leftMargin: 12 * pt

                Image
                {
                    id: walletNameEditButtonImage
                    anchors.fill: parent
                    source: parent.containsMouse ? "qrc:/resources/icons/ic_edit_hover.png" : "qrc:/resources/icons/ic_edit.png"
                    sourceSize.width: width
                    sourceSize.height: height

                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            DapButton
            {
                id: buttonNewPayment
                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                textButton: "New payment"
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#070023"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                normalImageButton: "qrc:/resources/icons/new-payment_icon.png"
                hoverImageButton: "qrc:/resources/icons/new-payment_icon.png"
                widthImageButton: 20 * pt
                heightImageButton: 20 * pt
                indentImageLeftButton: 15 * pt
                indentTextRight: 15 * pt
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
            }
        }
    }

    ListView
    {
        id: listViewWallet
        anchors.top: titleBlock.bottom
        anchors.topMargin: 20 * pt
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: 5 * pt
        clip: true

        delegate: delegateTokenView
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
