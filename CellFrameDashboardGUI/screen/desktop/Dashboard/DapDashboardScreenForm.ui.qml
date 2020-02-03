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
    property string bitCoinImagePath: "qrc:/res/icons/tkn1_icon_light.png"
    property string ethereumImagePath: "qrc:/res/icons/tkn2_icon.png"
    property string newGoldImagePath: "qrc:/res/icons/ng_icon.png"
    property string kelvinImagePath: "qrc:/res/icons/ic_klvn.png"
    ///@param dapButtonNewPayment Button to create a new payment.
    property alias dapButtonNewPayment: buttonNewPayment

    property alias dapListViewWallet: listViewWallet

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
                font.pixelSize: 20 * pt
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                text: "My first wallet"
            }

            MouseArea
            {
                id: walletNameEditButton
                width: 20 * pt
                height: 20 * pt
                hoverEnabled: true

                Image
                {
                    id: walletNameEditButtonImage
                    anchors.fill: parent
                    source: parent.containsMouse ? "qrc:/res/icons/ic_edit_hover.png" : "qrc:/res/icons/ic_edit.png"
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
                widthButton: 132 * pt
                heightButton: 36 * pt
                textButton: "New payment"
                colorBackgroundHover: "#D51F5D"
                colorBackgroundNormal: "#070023"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                normalImageButton: "qrc:/res/icons/new-payment_icon.png"
                hoverImageButton: "qrc:/res/icons/new-payment_icon.png"
                widthImageButton: 20 * pt
                heightImageButton: 20 * pt
                indentImageLeftButton: 20 * pt
                indentTextRight: 20 * pt
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
