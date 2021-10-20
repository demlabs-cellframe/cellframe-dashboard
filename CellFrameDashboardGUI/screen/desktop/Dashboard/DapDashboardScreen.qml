import QtQuick 2.4
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"


DapAbstractScreen
{
    id: dapDashboardScreen
    dapFrame.color: currTheme.backgroundMainScreen
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
    property alias dapFrameTitleCreateWallet: frameTitleCreateWallet


    Rectangle
    {
        id: walletCreateFrame
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle
            {
                height: 82.79 * pt
                width: parent.width
                color: "transparent"
            }
            Image
            {
                id: iconCreateWallet
                source: "qrc:/resources/icons/" + pathTheme + "/illustration-new-wallet.png"
                width: 500 * pt
                height: 300 * pt
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 45 * pt
                width: parent.width
                color: "transparent"
            }
            Text
            {
                id: titleTextWalletCreate
                font.family: "Quiksand"
                font.pixelSize: 26 * pt
                color: currTheme.textColor
                text: qsTr("Create a new wallet")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle
            {
                height: 21 * pt
                width: parent.width
                color: "transparent"
            }

            DapButton
            {
                id: addWalletButton

                implicitWidth: 180 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton
                anchors.horizontalCenter: parent.horizontalCenter
                textButton: "New wallet"
                colorBackgroundNormal: currTheme.buttonColorNormal
                colorBackgroundHover: currTheme.buttonColorHover
                colorButtonTextNormal: currTheme.textColor
                colorButtonTextHover: currTheme.textColor
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                horizontalAligmentText:Qt.AlignCenter
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
        id: frameTitleCreateWallet
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
//        anchors.verticalCenter: parent.verticalCenter
        Text
        {
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: "Quiksand"
            font.pixelSize: 26 * pt
            color: currTheme.textColor
            text: qsTr("Creating wallet in process...")
        }
    }

    Rectangle
    {
        id: titleBlock
        anchors.top: parent.top
        anchors.topMargin: 20 * pt
        anchors.bottomMargin: 20 * pt
        anchors.left: parent.left
        anchors.leftMargin: 20 * pt
        anchors.right: parent.right
        height: 36 * pt
        color: "transparent"

        RowLayout
        {
            anchors.fill: parent

            Text
            {
                id: titleText
                font.family: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegularCustom
                font.pixelSize: 20 * pt
                text: "My first crypto wallet"
                width: 185 * pt
                color: currTheme.textColor
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
                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
            }
        }
    }

    ListView
    {
        id: listViewWallet
        anchors.top: titleBlock.bottom
        anchors.topMargin: 20 * pt
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20 *pt
//        anchors.rightMargin: 10 *pt
        anchors.left: parent.left
        anchors.right: parent.right
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
                color: "transparent"

                Text
                {
                    id: stockNameText
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
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
                color: currTheme.backgroundElements

                Text
                {
                    id: networkAddressLabel
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16 * pt
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                    color: currTheme.textColor
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
                   fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
                   color: currTheme.textColor
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

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.margins: 10 * pt
                        spacing: 10 * pt

                        Image
                        {
                            id: currencyIcon
                            height: 30 * pt
                            width: 30 * pt
                            source: "qrc:/resources/icons/ic_cellframe.png"
                            sourceSize.width: width
                            sourceSize.height: height
                        }

                        Text
                        {
                            id: currencyName
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                            color: "#070023"
                            text: name
                            width: 172 * pt
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text
                        {
                            id: currencySum
                            Layout.fillWidth: true
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                            color: "#070023"
                            text: balance.toFixed(9)
//                            text: balance.toPrecision()
                            horizontalAlignment: Text.AlignRight
                        }

                        Text
                        {
                            id: currencyCode
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                            color: "#070023"
                            text: name
                            horizontalAlignment: Text.AlignRight
                        }

//                        Text
//                        {
//                            id: currencyEmission
//                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
//                            color: "#070023"
//                            text: emission + " datoshi"
//                            horizontalAlignment: Text.AlignRight
//                        }
                    }
                }
            }
        }
    }
}
