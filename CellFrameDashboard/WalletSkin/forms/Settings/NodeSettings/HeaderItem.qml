import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../../controls"
import "qrc:/widgets"

Item
{
    property string headerName: ""

    Layout.fillWidth: true
    height: 30

    //background
    Rectangle
    {
        id: itemRect
        anchors.fill: parent
        color: currTheme.thirdBackground
        radius: 12
    }

    DropShadow {
        anchors.fill: itemRect
        source: itemRect
        color: currTheme.mainBlockShadowDrop
        horizontalOffset: 1
        verticalOffset: 1
        radius: 0
        samples: 0
        opacity: 0.49
        fast: true
        cached: true
    }
    InnerShadow {
        id: shadow
        anchors.fill: itemRect
        radius: 5
        samples: 10
        horizontalOffset: 3
        verticalOffset: 3
        color: currTheme.shadowMain
        opacity: 0.33
        source: itemRect
        fast: true
        cached: true
    }

    Text
    {
        anchors.fill: parent
        anchors.topMargin: 1
        anchors.leftMargin: 14
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignLeft
        color: currTheme.white
        text: headerName
        font: mainFont.dapFont.medium12
    }
}
