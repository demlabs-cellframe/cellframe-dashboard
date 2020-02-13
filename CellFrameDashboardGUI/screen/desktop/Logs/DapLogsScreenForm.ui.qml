import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{

    id: logsBoard
    ///@detalis dapLogsListView Indicates an active item.
    property alias dapLogsListViewIndex: dapLogsList.currentIndex
    ///@detalis dapLogsListView Log list widget.
    property alias dapLogsListView: dapLogsList

    ListView
    {
        id: dapLogsList
        anchors.fill: parent
        anchors.topMargin: 24 * pt
        anchors.leftMargin: 24 * pt
        anchors.rightMargin: 24 * pt
        clip: true
        model: dapLogsModel
        delegate: delegateLogs
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateLogsHeader

        DapScrollViewHandling
        {
            id: logListScrollHandler
            viewData: dapLogsList
            scrollMouseAtArrow: logListScroll.mouseAtArrow
            z: -1
        }

    }

    DapScrollView
    {
        id: logListScroll
        scrollDownButtonImageSource: "qrc:/res/icons/ic_scroll-down.png"
        scrollDownButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-down_hover.png"
        scrollUpButtonImageSource: "qrc:/res/icons/ic_scroll-up.png"
        scrollUpButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-up_hover.png"
        viewData: dapLogsList
        //Assign DapScrollView with DapScrollViewHandling which must have no parent-child relationship
        onClicked: logListScrollHandler.scrollDirectionUp = !logListScrollHandler.scrollDirectionUp
        scrollButtonVisible: logListScrollHandler.scrollVisible
        scrollButtonArrowUp: logListScrollHandler.scrollDirectionUp
        scrollButtonRightMargin: 10 * pt
        scrollButtonTopMargin: dapLogsList.anchors.topMargin + 20 * pt
        scrollButtonBottomMargin: 10 * pt
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
