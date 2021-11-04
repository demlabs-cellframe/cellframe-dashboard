import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "qrc:/widgets"

Page {
    id: root

    header: DapTopPanel {
        StackView {
            id: headerStack
            anchors.fill: parent
            anchors.leftMargin: 20
        }
    }

    property alias dapHeader: headerStack
    property alias dapScreen: mainScreenStack
    property alias dapRightPanel: rightPanelStack

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        id: rootPageRow
        anchors.fill: parent

        DapScreenPage {
            Layout.fillHeight: true
            Layout.preferredWidth: rootPageRow.width * 0.7
            StackView {
                id: mainScreenStack
                clip: true
                anchors.fill: parent
                anchors.margins: 10
            }
        }

        DapScreenPage {
            Layout.fillHeight: true
            Layout.fillWidth: true
            StackView {
                id: rightPanelStack
                clip: true
                anchors.fill: parent
                anchors.margins: 10
            }
        }
    }
}
