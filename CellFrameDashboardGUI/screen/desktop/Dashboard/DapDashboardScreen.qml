import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"


DapAbstractScreen
{
    id: dapDashboardScreen
    anchors
    {
        fill: parent
        topMargin: 24 * pt
        rightMargin: 44 * pt
        leftMargin: 24 * pt
        bottomMargin: 20 * pt
    }

    // Paths to currency emblems
    property string bitCoinImagePath: "qrc:/resources/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/resources/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/resources/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/resources/icons/ic_klvn.png"
    ///@param dapButtonNewPayment Button to create a new payment.
//    property alias dapButtonNewPayment: buttonNewPayment
    property alias dapListViewWallet: listViewWallet
//    property alias dapNameWalletTitle: titleText
    property alias dapWalletCreateFrame: walletCreateFrame
//    property alias dapTitleBlock: titleBlock
    property alias dapAddWalletButton: addWalletButton
    property alias dapFrameTitleCreateWallet: frameTitleCreateWallet
    property alias dapMainFrameDashboard : mainFrameDashboard


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


    DapRectangleLitAndShaded
    {
        id: mainFrameDashboard
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
            {
                anchors.fill: parent

                // Header
                Item
                {
                    id: walletShowHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 38 * pt
                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 18 * pt
                        anchors.topMargin: 10 * pt
                        anchors.bottomMargin: 10 * pt

                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Tokens")
                        font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                        color: currTheme.textColor
                    }
                }

                ListView
                {
                    id: listViewWallet
                    anchors.top: walletShowHeader.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
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
                            color: currTheme.backgroundMainScreen

                            Text
                            {
                                id: stockNameText
                                anchors.left: parent.left
                                anchors.leftMargin: 16 * pt
                                anchors.verticalCenter: parent.verticalCenter
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                                color: currTheme.textColor
                                verticalAlignment: Qt.AlignVCenter
                                text: name
                            }

        //                    Text
        //                    {
        //                        id: networkAddressLabel
        //                        anchors.verticalCenter: parent.verticalCenter
        //                        anchors.left: parent.left
        //                        anchors.leftMargin: 16 * pt
        //                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
        //                        color: currTheme.textColor
        //                        text: qsTr("Network address")
        //                        width: 92 * pt
        //                    }
                            DapText
                            {
                               id: textMetworkAddress
        //                       anchors.left: parent.left
        //                       anchors.leftMargin: 500 * pt
                               width: 63 * pt
                               anchors.right:  networkAddressCopyButton.left
                               anchors.rightMargin: 4 * pt
                               anchors.verticalCenter: parent.verticalCenter
                               fontDapText: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
                               color: currTheme.textColor
                               fullText: address
                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft
                            }

                            MouseArea
                            {
                                id: networkAddressCopyButton
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 16 * pt
                                width: 16 * pt
                                height: 16 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()


                                Image
                                {
                                    id: networkAddressCopyButtonImage
                                    anchors.fill: parent
                                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
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
                                anchors.right: parent.right
                                height: 50 * pt
                                color: currTheme.backgroundElements

                                RowLayout
                                {
                                    anchors.fill: parent
                                    anchors.leftMargin: 20 * pt
                                    anchors.rightMargin: 20 * pt
                                    spacing: 10 * pt

                                    Text
                                    {
                                        id: currencyName
                                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                                        color: currTheme.textColor
                                        text: name
                                        width: 172 * pt
                                        horizontalAlignment: Text.AlignLeft
                                    }

                                    Text
                                    {
                                        id: currencySum
                                        Layout.fillWidth: true
                                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                                        color: currTheme.textColor
                                        text: balance.toFixed(9)
            //                            text: balance.toPrecision()
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Text
                                    {
                                        id: currencyCode
                                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                                        color: currTheme.textColor
                                        text: name
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }

                                //  Underline
                                Rectangle
                                {
                                    x: 20 * pt
                                    y: parent.height - 1 * pt
                                    width: parent.width - 40 * pt
                                    height: 1 * pt
                                    color: currTheme.lineSeparatorColor
                                }

                            }
                        }
                    }
                }

            }

    }
}
