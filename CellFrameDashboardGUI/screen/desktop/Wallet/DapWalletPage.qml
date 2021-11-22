import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../Wallet/RightPanel" as Rp
import "qrc:/screen/controls" as Controls
import "qrc:/screen/desktop"
import "qrc:/screen"

Controls.DapPage {

    property var networksList: _dapNetworksModel

    QtObject {
        id: navigator

        function openNewPayment() {
            dapRightPanel.push("qrc:/screen/desktop/Wallet/RightPanel/DapNewPayment.qml")
        }
    }

    dapHeader.initialItem: DapWalletTopPanel { }

    dapScreen.initialItem: DapWalletScreen { }

    dapRightPanel.initialItem: Rp.DapLastActions { }
}
