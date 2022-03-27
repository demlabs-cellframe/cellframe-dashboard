import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../"

Page
{
    property alias dapHistoryRightPanel: historyRightPanel

    anchors.fill: parent

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
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
                id: dapListViewHistory
                anchors.fill: parent
                model: modelHistory
                clip: true

                delegate: delegateToken

                section.property: "date"
                section.criteria: ViewSection.FullString
                section.delegate: delegateDate

                ScrollBar.vertical: ScrollBar {
                    active: true
                }
            }

        }

        TXHistoryRightPanel
        {
            id: historyRightPanel

            Layout.fillHeight: true
            Layout.minimumWidth: 350 * pt
        }
    }
}
