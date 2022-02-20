import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../Wallet/RightPanel" as Rp
import "qrc:/screen/controls" as Controls
import "qrc:/screen/desktop"
import "qrc:/screen"

Controls.DapPage {

    QtObject {
        id: navigator

        function openSomePage() {

        }
    }

    dapHeader.initialItem: VPNClientTopPanel { }

    dapScreen.initialItem: VPNClientScreen { }

    dapRightPanel.initialItem: VPNOrders { }
}
