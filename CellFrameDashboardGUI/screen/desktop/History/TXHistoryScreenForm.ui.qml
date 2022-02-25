import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import "qrc:/widgets"
import "../../"

Page
{
    anchors.fill: parent

    background: Rectangle {
        color: "transparent"
    }

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
