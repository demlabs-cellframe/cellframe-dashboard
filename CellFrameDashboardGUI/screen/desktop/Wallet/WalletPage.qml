import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/desktop/Wallet/RightPanel"
import "qrc:/screen/controls"

DapPage {

    property var networksList: _dapNetworksModel
    property var tokensModel: _tokensModel

    QtObject {
        id: navigator

        function openNewPayment() {
            dapRightPanel.push("qrc:/screen/desktop/Wallet/RightPanel/DapNewPayment.qml")
            console.info("dapRightPanel count NEW PAYMENT =", dapRightPanel.depth)
        }

        function openTestPage() {
            dapRightPanel.replace("qrc:/screen/desktop/TestPageForRightPannel.qml")
            console.info("dapRightPanel count TEST =", dapRightPanel.depth)
        }

        function clearRightPanel() {
            dapRightPanel.pop(null)
        }
    }

    dapHeader.initialItem: WalletTopPanel { }

    dapScreen.initialItem: WalletScreen { }

    dapRightPanel.initialItem: LastActions { }
}
