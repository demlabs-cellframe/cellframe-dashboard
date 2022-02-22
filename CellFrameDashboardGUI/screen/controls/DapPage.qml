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
//            anchors.leftMargin: 20
        }
    }

    property alias dapHeader: headerStack
    property alias dapScreen: mainScreenStack
    property alias dapRightPanel: rightPanelStack

    property bool onRightPanel: true

    background: Rectangle {
        color: currTheme.backgroundMainScreen
    }

    RowLayout {
        id: rootPageRow
        anchors.fill: parent

        DapScreenPage {
            Layout.fillHeight: true
            Layout.preferredWidth: onRightPanel? rootPageRow.width * 0.7: rootPageRow.width

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
            visible: onRightPanel
            Layout.fillWidth: true
            Layout.fillHeight: true
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
