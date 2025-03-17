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
    // property alias listViewWallet: walletShowFrame.listViewWallet
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

    DapDashboardWalletsShowScreen
    {
        id: walletShowFrame
        anchors.fill: parent
    }

}
