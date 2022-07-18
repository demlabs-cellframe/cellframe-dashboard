import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../controls"
import "qrc:/widgets"
import "../../"


Page
{
    id: dapDashboardScreen

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
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
//        anchors.topMargin: 41 * pt
        anchors.leftMargin: 301 * pt
        anchors.rightMargin: 281 * pt
        anchors.bottomMargin: 131 * pt

        color: "transparent"
        Column
        {
            y: 50 * pt
            x: 40 * pt
//            anchors.top: parent.top
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
//            Rectangle
//            {
//                height: 82.79 * pt
//                width: parent.width
//                color: "transparent"
//            }
            Item
            {
                //width: 450 * pt
                //height: 450 * pt
                width: iconCreateWallet.implicitWidth
                height: iconCreateWallet.implicitHeight

                //anchors.centerIn: parent

                Image
                {
                    anchors.fill: parent
                    id: iconCreateWallet
                    source: "qrc:/Resources/" + pathTheme + "/Illustratons/wallet_illustration.png"
                    sourceSize.width: 200 * pt
                    sourceSize.height: 200 * pt
                    fillMode: Image.PreserveAspectFit
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }
//            Rectangle
//            {
//                height: 45 * pt
//                width: parent.width
//                color: "transparent"
//            }

            Item
            {
                height: 30 * pt
                width: parent.width
            }

            Text
            {
                id: titleTextWalletCreate
                font: mainFont.dapFont.medium26
                color: currTheme.textColor
                text: qsTr("Create a new wallet")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item
            {
                height: 21 * pt
                width: parent.width
            }

            DapButton
            {
                id: addWalletButton

                implicitWidth: 165 * pt
                implicitHeight: 36 * pt
                anchors.horizontalCenter: parent.horizontalCenter
                textButton: qsTr("Get started")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText:Qt.AlignCenter
            }
            Item
            {
                height: Layout.fillHeight
                width: parent.width
            }
        }
    }
    Rectangle
    {
        FontLoader{id: font; source: "qrc:/resources/fonts/Quicksand/Quicksand-Medium.ttf"}
        property alias text: textTitle.text


        id: frameTitleCreateWallet
        anchors.fill: parent
        anchors.topMargin: 8 * pt
        anchors.leftMargin: 2 * pt
//        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
//        anchors.verticalCenter: parent.verticalCenter
        Text
        {
            id:textTitle
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: font.name
            font.pixelSize:26 * pt
//            font: mainFont.dapFont.medium26
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
                    height: 42 * pt
                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 18 * pt
                        anchors.topMargin: 10 * pt
                        anchors.bottomMargin: 10 * pt

                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Tokens")
                        font:  mainFont.dapFont.bold14
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
                        width: listViewWallet.width

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
                                font: mainFont.dapFont.medium11
                                color: currTheme.textColor
                                verticalAlignment: Qt.AlignVCenter
                                text: name
                            }

                            DapText
                            {
                               id: textMetworkAddress
                               width: 63 * pt
                               anchors.right:  networkAddressCopyButton.left
                               anchors.rightMargin: 4 * pt
                               anchors.verticalCenter: parent.verticalCenter
                               fontDapText: mainFont.dapFont.medium11
                               color: currTheme.textColor
                               fullText: address
                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft
                            }

                            /*MouseArea
                            {
                                id: networkAddressCopyButton
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 16 * pt
                                width: 16 * pt
                                height: 16 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()

                                Image{
                                    id:networkAddressCopyButtonImage
                                    width: parent.width
                                    height: parent.height
                                    mipmap: true
                                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                                }
                            }*/

                            CopyButton
                            {
                                id: networkAddressCopyButton
                                onCopyClicked: textMetworkAddress.copyFullText()
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 16 * pt
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
                                        font: mainFont.dapFont.regular16
                                        color: currTheme.textColor
                                        text: name
                                        width: 172 * pt
                                        horizontalAlignment: Text.AlignLeft
                                    }

                                    Text
                                    {
                                        id: currencySum
                                        Layout.fillWidth: true
                                        font: mainFont.dapFont.regular14
                                        color: currTheme.textColor
                                        text: balance_without_zeros
//                                        text: full_balance
//                                        text: datoshi
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Text
                                    {
                                        id: currencyCode
                                        font: mainFont.dapFont.regular14
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
