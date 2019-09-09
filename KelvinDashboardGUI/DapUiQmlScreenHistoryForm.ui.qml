import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

import DapTransactionHistory 1.0

Page {
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
