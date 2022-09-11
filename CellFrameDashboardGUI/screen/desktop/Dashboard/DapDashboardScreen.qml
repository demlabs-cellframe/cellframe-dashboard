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
//        anchors.topMargin: 41 
        anchors.leftMargin: 301 
        anchors.rightMargin: 281 
        anchors.bottomMargin: 131 

        color: "transparent"
        Column
        {
            y: 50 
            x: 40 
//            anchors.top: parent.top
//            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
//            Rectangle
//            {
//                height: 82.79 
//                width: parent.width
//                color: "transparent"
//            }
            Item
            {
                //width: 450 
                //height: 450 
                width: iconCreateWallet.implicitWidth
                height: iconCreateWallet.implicitHeight

                //anchors.centerIn: parent

                Image
                {
                    anchors.fill: parent
                    id: iconCreateWallet
                    source: "qrc:/Resources/" + pathTheme + "/Illustratons/wallet_illustration.png"
                    sourceSize.width: 200 
                    sourceSize.height: 200 
                    fillMode: Image.PreserveAspectFit
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }
//            Rectangle
//            {
//                height: 45 
//                width: parent.width
//                color: "transparent"
//            }

            Item
            {
                height: 30 
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
                height: 21 
                width: parent.width
            }

            DapButton
            {
                id: addWalletButton

                implicitWidth: 165 
                implicitHeight: 36 
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
        anchors.topMargin: 8 
        anchors.leftMargin: 2 
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
            font.pixelSize:26 
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
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                Item
                {
                    id: walletShowHeader
                    Layout.fillWidth: true
                    height: 42

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        font: mainFont.dapFont.bold14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("Tokens")
                    }
                }

                ListView
                {
                    id: listViewWallet
                    Layout.fillHeight: true
                    Layout.fillWidth: true
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
                            height: 30 
                            width: parent.width
                            color: currTheme.backgroundMainScreen

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 0

                                Text
                                {
                                    Layout.fillWidth: true
                                    font: mainFont.dapFont.medium12
                                    color: currTheme.textColor
                                    verticalAlignment: Qt.AlignVCenter
                                    text: name
                                }

                                Item{Layout.fillWidth: true}


                                DapText
                                {
                                   id: textMetworkAddress
                                   Layout.alignment: Qt.AlignRight
                                   Layout.rightMargin: 5
                                   Layout.minimumWidth: 68
                                   Layout.maximumWidth: 68
                                   Layout.fillHeight: true

                                   fontDapText: mainFont.dapFont.regular12
                                   color: currTheme.textColor
                                   fullText: address
                                   textElide: Text.ElideMiddle
                                   horizontalAlignment: Qt.AlignLeft
                                   verticalAlignment: Qt.AlignVCenter
                                }

                                DapCopyButton
                                {
                                    id: networkAddressCopyButton
                                    onCopyClicked: textMetworkAddress.copyFullText()
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 16
                                    popupText: qsTr("Address copied")
                                }
                            }

/*                            CopyButton
                            {
                                id: networkAddressCopyButton
                                onCopyClicked: textMetworkAddress.copyFullText()
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 16 * pt
                            }*/
                        }

                        Repeater
                        {
                            width: parent.width
                            model: tokens

                            Rectangle
                            {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 50 
                                color: currTheme.backgroundElements

                                RowLayout
                                {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 10 

                                    Text
                                    {
                                        id: currencyName
                                        font: mainFont.dapFont.regular16
                                        color: currTheme.textColor
                                        text: name
                                        width: 172 
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
                                    x: 16
                                    y: parent.height - 1 
                                    width: parent.width - 32
                                    height: 1 
                                    color: currTheme.lineSeparatorColor
                                }
                            }
                        }
                    }
                }
            }
    }
}
