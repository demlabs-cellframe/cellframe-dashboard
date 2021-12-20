import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "qrc:/screen/controls" as Controls

Page {
    id: root

    header: Controls.DapTopPanel {
        StackView {
            id: headerStack
            anchors.fill: parent
            anchors.leftMargin: 20
        }
    }

    property bool screenOverlay: false
    property bool rightPanelOverlay: false

    property alias dapHeader: headerStack
    property alias dapScreen: mainScreenStack
    property alias dapRightPanel: rightPanelStack

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        id: rootPageRow
        anchors.fill: parent

        StackView {
            id: mainScreenStack
            clip: true
            Layout.fillHeight: true
            Layout.preferredWidth: rootPageRow.width * 0.7
            //            Layout.preferredWidth: rightPanelStack.depth > 0 ?
            //                                       rootPageRow.width * 0.7 :
            //                                       rootPageRow.width
        }

        StackView {
            id: rightPanelStack
            clip: true
            Layout.fillHeight: true
            //Layout.fillWidth: rightPanelStack.depth > 0 ? true : false
            Layout.fillWidth: true
        }
    }
}
