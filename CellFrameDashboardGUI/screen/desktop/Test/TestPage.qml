import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "../"
import "qrc:/screen/controls" as Controls

Controls.DapPage {

    QtObject {
        id: navigator

        function openPage2() {
            dapRightPanel.push("qrc:/screen/desktop/TestPageForRightPannel2.qml")
        }
    }

    dapHeader.initialItem: TestPageForTopPanel { }

    dapScreen.initialItem: TestScreen { }

    dapRightPanel.initialItem: TestPageForRightPannel { }
}
