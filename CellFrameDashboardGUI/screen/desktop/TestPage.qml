import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "qrc:/"
import "../"
import "qrc:/widgets"
import "../controls" as Controls

Controls.DapPage {
    id: testPageTab

    header:
        DapTopPanel {
        id: header
        anchors.leftMargin: 4*pt
        radius: currTheme.radiusRectangle
        color: currTheme.backgroundPanel
    }

    dapScreen:
        StackView {
        id: screen
        anchors.fill: parent
        initialItem: TestScreen { }
    }

    dapRightPanel:
        StackView {
        id: rightPanel
        anchors.fill: parent
        initialItem: DapRightPanel {
            title: qsTr("Test Title")
        }
    }
}
