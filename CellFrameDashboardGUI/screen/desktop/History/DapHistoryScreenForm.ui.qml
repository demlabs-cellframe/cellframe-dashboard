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

    anchors
    {
        fill: parent
        margins: 24 * pt
    }

    Rectangle
    {
        id: mainFrameHistory
        anchors.fill: parent
        color: currTheme.backgroundElements

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

}
