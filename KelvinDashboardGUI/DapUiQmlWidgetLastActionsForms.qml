import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import DapTransactionHistory 1.0

Rectangle {
    width: 400 * pt
    border.color: "#B5B5B5"
    border.width: 1 * pt
    color: "#EDEFF2"

    anchors {
        top: parent.top
        right: parent.right
        bottom: parent.bottom
    }

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

    DapUiQmlWidgetLastActionsHeaderForms {
        id: dapHeader
    }

    ListView {
        id: dapListView
        anchors.top: dapHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        model: dapHistoryModel
        delegate: DapUiQmlWidgetLastActionsDelegateForms {}
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: DapUiQmlWidgetLastActionsSectionForms {}

        property var contentPos: 0.0;
        onContentYChanged: {
            if(atYBeginning) buttonListScroll.state = "goUp";
            else if(atYEnd) buttonListScroll.state = "goDown"
            else if(contentPos < contentItem.y) buttonListScroll.state = "goUp";
            else buttonListScroll.state = "goDown";

            contentPos = contentItem.y;
        }

        DapUiQmlWidgetLastActionsButtonForms {
            id: buttonListScroll
            viewData: dapListView
        }
    }
}
