//import QtQuick 2.4
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    color: currTheme.backgroundMainScreen

    property alias dapHistoryRightPanel: historyRightPanel

    property alias dapHistoryVerticalScrollBar: historyVerticalScrollBar

    property alias dapListViewHistory: listViewHistory

    anchors
    {
        fill: parent
        margins: 24 * pt
        rightMargin: 22 * pt
        bottomMargin: 20 * pt
    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 24 * pt

        DapRectangleLitAndShaded
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            anchors.fill: parent
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
            ListView
            {
                id: listViewHistory
                anchors.fill: parent
                model: modelHistory
                clip: true

                delegate: delegateToken

                section.property: "date"
                section.criteria: ViewSection.FullString
                section.delegate: delegateDate

                ScrollBar.vertical: ScrollBar {
                    id: historyVerticalScrollBar
                    active: true
                }
            }

        }

        DapHistoryRightPanel
        {
            id: historyRightPanel

            Layout.fillHeight: true
            Layout.minimumWidth: 350 * pt
        }

    }

}
