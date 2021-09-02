import QtQuick 2.4
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
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 82.79 * pt
                width: parent.width
            }
            Image
            {
                id: iconCreateWallet
                source: "qrc:/resources/icons/illustration_new-wallet.svg"
                width: 500 * pt
                height: 300 * pt
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 45 * pt
                width: parent.width
            }
            Text
            {
                id: titleTextWalletCreate
                font.family: "Quiksand"
                font.pixelSize: 26 * pt
                color: "#070023"
                text: qsTr("Create a new wallet")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 21 * pt
                width: parent.width
            }
            DapButton
            {
                id: addWalletButton

                implicitWidth: 180 * pt
                implicitHeight: 36 * pt
                radius: 4 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                heightImageButton: 21 * pt
                widthImageButton: 22 * pt
                textButton: "New wallet"
                normalImageButton: "qrc:/resources/icons/new-wallet_icon_dark.svg"
                hoverImageButton: "qrc:/resources/icons/new-wallet_icon_dark_hover.svg"
                indentImageLeftButton: 41 * pt
                colorBackgroundNormal: "#070023"
                colorBackgroundHover: "#D51F5D"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                indentTextRight: 37 * pt
                fontButton: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular14
                borderColorButton: "#000000"
                borderWidthButton: 0
                horizontalAligmentText:Qt.AlignRight
                colorTextButton: "#FFFFFF"

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
                //anchors.left: titleText.right
                //anchors.leftMargin: 12 * pt

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




    Component
    {
        id: delegateTokenView
        Column
        {
            width: parent.width

            Rectangle
            {
                id: stockNameBlock
                height: 30 * pt
                width: parent.width
                color: "#908D9D"

                Text
                {
                    id: stockNameText
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    color: "#FFFFFF"
                    verticalAlignment: Qt.AlignVCenter
                    text: name
                }
            }

            Rectangle
            {
                id: networkAddressBlock
                height: 40 * pt
                width: parent.width

                Text
                {
                    id: networkAddressLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                    color: "#908D9D"
                    text: qsTr("Network address")
                    width: 92 * pt
                }

                DapText
                {
                   id: textMetworkAddress
                   anchors.left: networkAddressLabel.right
                   anchors.leftMargin: 36 * pt
                   anchors.right:  networkAddressCopyButton.left
                   anchors.rightMargin: 4 * pt
                   anchors.verticalCenter: parent.verticalCenter
                   fontDapText: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular10
                   color: "#908D9D"
                   fullText: address
                   textElide: Text.ElideRight
                }



                MouseArea
                {
                    id: networkAddressCopyButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: networkAddressLabel.anchors.leftMargin
                    width: 16 * pt
                    height: 16 * pt
                    hoverEnabled: true

                    onClicked: textMetworkAddress.copyFullText()


                    Image
                    {
                        id: networkAddressCopyButtonImage
                        anchors.fill: parent
                        source: parent.containsMouse ? "qrc:/resources/icons/ic_copy_hover.png" : "qrc:/resources/icons/ic_copy.png"
                        sourceSize.width: parent.width
                        sourceSize.height: parent.height

                    }
                }
            }

            Repeater
            {
                width: parent.width
                model: tokens

                Rectangle
                {
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.right: parent.right
                    anchors.rightMargin: 16 * pt
                    height: 67 * pt

                    Rectangle
                    {
                        id: lineBalance
                        anchors.top: parent.top
                        width: parent.width
                        height: 1 * pt
                        color: "#908D9D"
                    }

                    Rectangle
                    {
                        anchors.top: lineBalance.bottom
                        anchors.topMargin: 24 * pt
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 12 * pt
                        color: "transparent"

                        Image
                        {
                            id: currencyIcon
                            anchors.left: parent.left
                            height: 30 * pt
                            width: 30 * pt
                            source: "qrc:/resources/icons/ic_cellframe.png"
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text
                        {
                            id: currencyName
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: currencyIcon.right
                            anchors.leftMargin: 10 * pt
                            font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular18
                            color: "#070023"
                            text: name
                            width: 172 * pt
                            horizontalAlignment: Text.AlignLeft

                        }

                        Rectangle
                        {
                            id: frameBalance
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"
                            width: 188 * pt
                            anchors.left: currencyName.right
                            anchors.leftMargin: 16 * pt
                            Text
                            {
                                id: currencySum
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                                color: "#070023"
                                text: balance + " "
                                horizontalAlignment: Text.AlignLeft

                            }

                            Text
                            {
                                id: currencyCode
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: currencySum.right
                                anchors.right: parent.right
                                font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                                color: "#070023"
                                text: name
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        Text
                        {
                            id: currencyDollarEqv
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: frameBalance.right
                            anchors.leftMargin: 16 * pt
                            anchors.right: parent.right
                            anchors.rightMargin: 16 * pt
                            font: dapMainFonts.dapMainFontTheme.dapFontRobotoRegular12
                            color: "#070023"
                            text: "$" + emission + " USD"
                            width: 188 * pt
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                }
            }
        }
    }
}
