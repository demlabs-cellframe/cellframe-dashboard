import QtQuick 2.4
import QtQuick.Controls 2.0
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
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
