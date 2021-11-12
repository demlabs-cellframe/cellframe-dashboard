import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/controls" as Controls
import "qrc:/screen/desktop"

Controls.DapPage {

    QtObject {
        id: navigator

        function openNewPayment() {
            dapRightPanel.push()
        }
    }

    dapHeader.initialItem: DapWalletTopPanel { }

    dapScreen.initialItem: DapWalletScreen { }

    dapRightPanel.initialItem: TestPageForRightPannel { }
}
