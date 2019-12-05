import QtQuick 2.0

DapUiQmlScreen {
    ListView {
        id: dapListView
        anchors.fill: parent
        model: dapHistoryModel
        delegate: delegateConetnet
        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateDate
    }
}
