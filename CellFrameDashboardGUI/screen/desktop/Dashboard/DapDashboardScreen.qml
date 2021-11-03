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
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 44 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
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

//        Rectangle
//        {
//            id: titleBlock
//            anchors.top: parent.top
//            anchors.topMargin: 20 * pt
//            anchors.bottomMargin: 20 * pt
//            anchors.left: parent.left
//            anchors.leftMargin: 20 * pt
//            anchors.right: parent.right
//            height: 36 * pt
//            color: "transparent"

//            RowLayout
//            {
//                anchors.fill: parent

//                Text
//                {
//                    id: titleText
//                    font.family: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegularCustom
//                    font.pixelSize: 20 * pt
//                    text: "My first crypto wallet"
//                    width: 185 * pt
//                    color: currTheme.textColor
//                }

//                MouseArea
//                {
//                    id: walletNameEditButton
//                    width: 16 * pt
//                    height: 16 * pt
//                    hoverEnabled: true
//                    //anchors.left: titleText.right
//                    //anchors.leftMargin: 12 * pt

//                    Image
//                    {
//                        id: walletNameEditButtonImage
//                        anchors.fill: parent
//                        source: parent.containsMouse ? "qrc:/resources/icons/ic_edit_hover.png" : "qrc:/resources/icons/ic_edit.png"
//                        sourceSize.width: width
//                        sourceSize.height: height

//                    }
//                }

//                Item
//                {
//                    Layout.fillWidth: true
//                    Layout.fillHeight: true
//                }

//                DapButton
//                {
//                    id: buttonNewPayment
//                    implicitWidth: 132 * pt
//                    implicitHeight: 36 * pt
//                    textButton: "New payment"
//                    colorBackgroundHover: "#D51F5D"
//                    colorBackgroundNormal: "#070023"
//                    colorButtonTextNormal: "#FFFFFF"
//                    colorButtonTextHover: "#FFFFFF"
//                    normalImageButton: "qrc:/resources/icons/new-payment_icon.png"
//                    hoverImageButton: "qrc:/resources/icons/new-payment_icon.png"
//                    widthImageButton: 20 * pt
//                    heightImageButton: 20 * pt
//                    indentImageLeftButton: 15 * pt
//                    indentTextRight: 15 * pt
//                    fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular12
//                }
//            }
//        }

        Rectangle
        {
            id: mainFrameDashboard
            anchors.fill: parent
            color: currTheme.backgroundElements
            radius: 16*pt

            // Header
            Item
            {
                id: walletShowHeader
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
    //            width: parent.width
                height: 38 * pt
    //            color: currTheme.backgroundElements
    //            radius: 16*pt
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    anchors.topMargin: 10 * pt
                    anchors.bottomMargin: 10 * pt
//                    anchors.verticalCenter: parent.verticalCenter

                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Tokens")
                    font:  dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                    color: currTheme.textColor
                }
            }

            ListView
            {
                id: listViewWallet
    //            anchors.fill: parent
                anchors.top: walletShowHeader.bottom
    //            anchors.topMargin: 20 * pt
                anchors.bottom: parent.bottom
    //            anchors.leftMargin: 20 *pt
    //            anchors.rightMargin: 10 *pt
                anchors.left: parent.left
                anchors.right: parent.right
    //            spacing: 5 * pt
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
                            anchors.leftMargin: 13 * pt
                            anchors.right: parent.right
                            anchors.rightMargin: 16 * pt
                            height: 50 * pt
                            color: currTheme.backgroundElements

                            Rectangle
                            {
                                anchors.top: tokenInfoPlace.bottom
                                width: parent.width
                                height: 1 * pt
                                color: currTheme.lineSeparatorColor
                            }

                            Item
                            {
                                id:tokenInfoPlace
                                anchors.fill: parent
                                anchors.bottomMargin: 1*pt
//                                height: 50 * pt
//                                anchors.margins: 10 * pt
//                                spacing: 10 * pt

                                Text
                                {
                                    id: currencyName
                                    anchors.left: parent.left
                                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular16
                                    color: currTheme.textColor
                                    text: name + " (" + currencyCode.text + ")"
                                    width: 172 * pt
                                    horizontalAlignment: Text.AlignLeft
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 10*pt

                                }

                                Text
                                {
                                    id: currencySum
//                                    Layout.fillWidth: true
                                    anchors.right: currencyCode.left
                                    anchors.rightMargin: 5 * pt
                                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                    color: currTheme.textColor
                                    text: balance.toFixed(9)
        //                            text: balance.toPrecision()
                                    horizontalAlignment: Text.AlignRight
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 10*pt
                                }

                                Text
                                {
                                    id: currencyCode
                                    anchors.right: parent.right
                                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                                    color: currTheme.textColor
                                    text: name
                                    horizontalAlignment: Text.AlignRight
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 10*pt
                                }
                            }

                        }
                        Component.onCompleted:
                        {
                            if(tokens.count === 0)
                                console.log("")
                        }
                    }
                }
            }

    }
    InnerShadow {
        id: topLeftSadow
        anchors.fill: mainFrameDashboard
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: mainFrameDashboard
        visible: mainFrameDashboard.visible
    }
    InnerShadow {
        anchors.fill: mainFrameDashboard
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: mainFrameDashboard.visible
    }
}
