import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "RightPanel"
import "qrc:/"
import "../../"
import "../controls"
import QtQml 2.12

DapPage {
    id: vpnCLientTab

    property bool isReceiptsOpen: false

    QtObject {
        id: vpnClientNavigator

        function openRefoundItem() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/Refund.qml")
            isReceiptsOpen = false
        }

        function openTopUpItem() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/TopUp.qml")
            isReceiptsOpen = false
        }

        function openVpnOrders() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/VPNOrders.qml")
            isReceiptsOpen = false
        }

        function openVpnReceipts() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/Receipts.qml")
            isReceiptsOpen = true
        }

        function openVpnReceiptsDetails(headerText) {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/ReceiptsDetails.qml", {"headerText" : headerText})
        }

        function closeVpnReceiptsDetails() {
            dapRightPanel.clear()
            dapRightPanel.push("qrc:/screen/desktop/VPNClient/RightPanel/Receipts.qml", StackView.PopTransition)
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
            _isReceiptsOpen: isReceiptsOpen
        }
}
