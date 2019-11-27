import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import DapTransactionHistory 1.0

DapUiQmlWidgetLastActionsForm {

    property alias viewModel: dapListView.model
    property alias viewDelegate: dapListView.delegate
    property alias viewSection: dapListView.section

    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if(!buttonListScroll.isHovered)
                buttonListScroll.visible = true;
        }

        onExited: {
            if(!buttonListScroll.isHovered)
                buttonListScroll.visible = false;
        }
    }

//    DapUiQmlWidgetLastActionsHeaderForm {
//        id: dapHeader
//        height: 36 * pt
//        anchors.left: parent.left
//        anchors.top: parent.top
//        anchors.right: parent.right
//        anchors.leftMargin: 1 * pt
//    }

//    Rectangle {
//        id: splitHeader
//        anchors.top: dapHeader.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right
//        height: 1 * pt
//        color: "#C2CAD1"
//    }

    ListView {
        id: dapListView
        anchors.fill: parent
//        anchors.top: splitHeader.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
        clip: true

        property var contentPos: 0.0;
        onContentYChanged: {
            if(atYBeginning) buttonListScroll.state = "goUp";
            else if(atYEnd) buttonListScroll.state = "goDown"
            else if(contentPos < contentItem.y) buttonListScroll.state = "goUp";
            else buttonListScroll.state = "goDown";

            contentPos = contentItem.y;
        }

        DapUiQmlWidgetLastActionsButtonForm {
            id: buttonListScroll
            viewData: dapListView
        }
    }
}
