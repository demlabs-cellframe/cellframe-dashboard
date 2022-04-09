import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../controls" as Controls

Page {
    id: root

    header: Controls.DapTopPanel {
        id: frameHeader
        StackView {
            id: headerStack
            anchors.fill: parent
//            anchors.leftMargin: 20
        }
    }

    property alias dapHeader: headerStack
    property alias dapHeaderFrame: frameHeader
    property alias dapScreen: mainScreenStack
    property alias dapRightPanel: rightPanelStack
    property alias dapRightPanelFrame: frameRightPanel

    property bool onRightPanel: true

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        id: rootPageRow
        anchors
        {
            fill: parent
            margins: 24 * pt
            bottomMargin: 23 * pt
        }

        spacing: 24 * pt

        DapScreenPage {
            Layout.fillHeight: true
            Layout.fillWidth: true
//            Layout.preferredWidth: onRightPanel? rootPageRow.width * 0.7: rootPageRow.width
            data:
            StackView {
                id: mainScreenStack
                anchors.fill: parent
                clip: true
                //            Layout.preferredWidth: rightPanelStack.depth > 0 ?
                //                                       rootPageRow.width * 0.7 :
                //                                       rootPageRow.width
            }
        }

        DapScreenPage {
            id: frameRightPanel
            visible: onRightPanel
//            Layout.fillWidth: true
            Layout.maximumWidth: 350
            Layout.minimumWidth: 350
            Layout.fillHeight: true
            data:
            StackView {
                id: rightPanelStack
                anchors.fill: parent
                clip: true
                //            Layout.preferredWidth: rightPanelStack.depth > 0 ?
                //                                       rootPageRow.width * 0.7 :
                //                                       rootPageRow.width
            }
        }

        //        StackView {
        //            id: mainScreenStack
        //            clip: true
        //            Layout.fillHeight: true
        //            Layout.preferredWidth: rootPageRow.width * 0.7
        //            //            Layout.preferredWidth: rightPanelStack.depth > 0 ?
        //            //                                       rootPageRow.width * 0.7 :
        //            //                                       rootPageRow.width
        //        }

        //        StackView {
        //            id: rightPanelStack
        //            clip: true
        //            Layout.fillHeight: true
        //            //Layout.fillWidth: rightPanelStack.depth > 0 ? true : false
        //            Layout.fillWidth: true
        //        }
    }
}
