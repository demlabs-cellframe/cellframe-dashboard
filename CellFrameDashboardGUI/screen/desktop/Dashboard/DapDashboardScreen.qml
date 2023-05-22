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
        color: currTheme.mainBackground
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
    property alias walletDefaultFrame: walletDefaultFrame
//    property alias dapTitleBlock: titleBlock
    property alias walletCreateFrame: walletCreateFrame
    property alias walletShowFrame : walletShowFrame


    DapDashboardNoWalletsScreen
    {
        id: walletDefaultFrame
        anchors.fill: parent
    }

    DapDashboardCreateWalletsScreen
    {
        id: walletCreateFrame
        anchors.fill: parent
    }


    DapRectangleLitAndShaded
    {
        id: walletShowFrame
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
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
                        color: currTheme.white
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
                            color: currTheme.mainBackground

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
                                    color: currTheme.white
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
                                   color: currTheme.white
                                   fullText: address
                                   textElide: Text.ElideMiddle
                                   horizontalAlignment: Qt.AlignLeft
                                   verticalAlignment: Qt.AlignVCenter
                                }

                                DapCopyButton
                                {
                                    id: networkAddressCopyButton
                                    onCopyClicked: textMetworkAddress.copyFullText()
                                    Layout.alignment: Qt.AlignRight
//                                    anchors.verticalCenter: parent.verticalCenter
//                                    anchors.right: parent.right
//                                    anchors.rightMargin: 16
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
                                color: currTheme.secondaryBackground

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
                                        color: currTheme.white
                                        text: name
                                        width: 172 
                                        horizontalAlignment: Text.AlignLeft
                                    }

                                    Item{
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        DapBigText
                                        {
                                            id: currencySum
                                            anchors.fill: parent
                                            textFont: mainFont.dapFont.regular14
                                            fullText: coins
                                            horizontalAlign: Text.AlignRight
                                        }
                                    }



                                    Text
                                    {
                                        id: currencyCode
                                        font: mainFont.dapFont.regular14
                                        color: currTheme.white
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
                                    color: currTheme.mainBackground
                                }
                            }
                        }
                    }
                }
            }
    }
}
