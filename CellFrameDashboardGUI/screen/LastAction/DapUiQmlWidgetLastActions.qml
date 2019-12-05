import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

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

    ListView {
        id: dapListView
        anchors.fill: parent
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
