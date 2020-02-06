import QtQuick 2.4
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
        model: testModel
        delegate: delegateToken
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateDate
    }
}
