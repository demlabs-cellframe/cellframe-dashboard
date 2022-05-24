import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "Parts"
import "qrc:/"
import "../../"
import "../controls"

DapPage {
    id:vpnCLientTab
	
    property alias dapTokenModel: tokenModel

    readonly property string vpnOrdersPage: "RightPanel/VPNOrders.qml"
    readonly property string topUpPage: "RightPanel/TopUp.qml"
    readonly property string refundPage: "RightPanel/Refund.qml"

    signal goToHomePage()

    ListModel {
        id: tokenModel
        ListElement {
            name: "KLVN"
        }
        ListElement {
            name: "DAPS"
        }
        ListElement {
            name: "EOS"
        }
        ListElement {
            name: "USDT"
        }
    }

    dapScreen.initialItem: DapVpnClientScreen
    {

    }

    dapRightPanel.initialItem:
        RightStackView
        {
            id: rightStackView
//            Layout.fillHeight: true
        }

    dapHeader.initialItem:
        DapVpnClientTopPanel
        {

        }

    Component.onCompleted:
    {
        rightStackView.setInitialItem(vpnOrdersPage)
//        rightStackView.setInitialItem("RightPanel/TopUp.qml")
    }

    onGoToHomePage:
    {
        rightStackView.setInitialItem(vpnOrdersPage)
    }

//    color: currTheme.backgroundMainScreen

//    property alias dapVpnClientRightPanel: stackViewRightPanel

//    dapTopPanel:
//        DapVpnClientTopPanel
//        {

//        }

//    dapScreen:
//        DapVpnClientScreen
//        {

//        }

//    dapRightPanel:
//        StackView
//        {
//            id: stackViewRightPanel
////            initialItem: Qt.resolvedUrl(lastActionsWallet);
//            width: 350
//            anchors.fill: parent
//            delegate:
//                StackViewDelegate
//                {
//                    pushTransition: StackViewTransition { }
//                }
//        }
}
