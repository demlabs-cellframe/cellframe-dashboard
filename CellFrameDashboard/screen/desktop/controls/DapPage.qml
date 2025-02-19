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
        color: currTheme.mainBackground
    }

    RowLayout {
        id: rootPageRow
        anchors
        {
            fill: parent
            margins: 24 
            bottomMargin: 23 
        }

        spacing: 24 

        DapScreenPage {
            Layout.fillHeight: true
            Layout.fillWidth: true

            data:
            StackView {
                id: mainScreenStack
                anchors.fill: parent
                clip: true
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

//                pushEnter: Transition {
//                        id: pushEnter
//                        ParallelAnimation {
////                            PropertyAction { property: "x"; value: pushEnter.ViewTransition.item.pos }
////                            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
//                        }
//                    }
//                    popExit: Transition {
//                        id: popExit
//                        ParallelAnimation {
////                            PropertyAction { property: "x"; value: popExit.ViewTransition.item.pos }
////                            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
//                        }
//                    }

                pushExit: Transition {
                    id: pushExit
                    PropertyAction { property: "x"; value: pushExit.ViewTransition.item.pos }
                }
                popEnter: Transition {
                    id: popEnter
                    PropertyAction { property: "x"; value: popEnter.ViewTransition.item.pos }
                }

                pushEnter: Transition {
                    PropertyAnimation {
                        property: "x"
                        easing.type: Easing.Linear
                        from: 350
                        to: 0
                        duration: 350
                    }
                }
                popExit: Transition {
                    PropertyAnimation {
                        property: "x"
                        from: 0
                        to: 350
                        duration: 350
                    }
                }
            }
        }
    }
}
