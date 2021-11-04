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

    header:
        DapTopPanel {
        id: header
        anchors.leftMargin: 4*pt
        radius: currTheme.radiusRectangle
        color: currTheme.backgroundPanel
    }

    dapScreen.initialItem: TestScreen { }

    dapRightPanel.initialItem: TestPageForRightPannel { }
}
