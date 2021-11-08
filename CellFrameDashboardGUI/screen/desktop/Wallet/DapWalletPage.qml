import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/screen/controls" as Controls

Controls.DapPage {
    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 16 * pt
    }

    dapHeader.initialItem: DapWalletTopPanel {}

    dapScreen.initialItem: {}
}

