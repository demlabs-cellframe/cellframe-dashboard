import QtQuick 2.4
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    ListView
    {
        id: dapListViewHistory
        anchors.fill: parent

        anchors.topMargin: 24 * pt
        anchors.leftMargin: 24 * pt
        anchors.rightMargin: 24 * pt
        model: modelHistory
        delegate: delegateToken
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateDate
        clip: true

        DapScrollViewHandling
        {
            id: historyListScrollHandler
            viewData: dapListViewHistory
            scrollMouseAtArrow: historyListScroll.mouseAtArrow
            z: -1
        }
    }

    DapScrollView
    {
        id: historyListScroll
        scrollDownButtonImageSource: "qrc:/res/icons/ic_scroll-down.png"
        scrollDownButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-down_hover.png"
        scrollUpButtonImageSource: "qrc:/res/icons/ic_scroll-up.png"
        scrollUpButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-up_hover.png"
        viewData: dapListViewHistory
        //Assign DapScrollView with DapScrollViewHandling which must have no parent-child relationship
        onClicked: historyListScrollHandler.scrollDirectionUp = !historyListScrollHandler.scrollDirectionUp
        scrollButtonVisible: historyListScrollHandler.scrollVisible
        scrollButtonArrowUp: historyListScrollHandler.scrollDirectionUp
        scrollButtonRightMargin: 10 * pt
        scrollButtonTopMargin: dapListViewHistory.anchors.topMargin + 20 * pt
        scrollButtonBottomMargin: 10 * pt
    }
}
