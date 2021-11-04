import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "qrc:/"
import "../"
import "qrc:/widgets"
import "../controls" as Controls

Controls.DapPage {
    id: testPageTab

    QtObject {
        id: navigator

        function openPage2() {
            dapRightPanel.push("qrc:/screen/desktop/TestPageForRightPannel2.qml")
        }        
    }

    // StackView
    dapHeader.initialItem: TestPageForTopPanel { }

    // StackView
    dapScreen.initialItem: TestScreen { }

    // StackView
    dapRightPanel.initialItem: TestPageForRightPannel { }
}
