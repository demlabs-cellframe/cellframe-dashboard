import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "RightPanel"
import "qrc:/"
import "../../"
import "../controls"
import QtQml 2.12

DapPage {
    id:vpnCLientTab
	
   // property alias dapTokenModel: tokenModel

    readonly property string vpnOrdersPage: "RightPanel/VPNOrders.qml"
    readonly property string topUpPage: "RightPanel/TopUp.qml"
    readonly property string refundPage: "RightPanel/Refund.qml"

    QtObject {
        id: vpnClientNavigator

        function openRefoundItem() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient-new/RightPanel/Refund.qml")
        }

        function openTopUpItem() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient-new/RightPanel/TopUp.qml")
        }

        function openVpnOrders() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient-new/RightPanel/VPNOrders.qml")
        }

        function openVpnReceipts() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient-new/RightPanel/Receipts.qml")
        }
    }

    dapScreen.initialItem: DapVpnClientScreen
    {

    }

    dapRightPanel.initialItem:
        VPNOrders
        {
        }

    dapHeader.initialItem:
        DapVpnClientTopPanel
        {

        }
}
