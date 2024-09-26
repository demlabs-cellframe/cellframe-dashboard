import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Component
{
    id: delegateSection
    Item{
        property date payDate: new Date(Date.parse(section))

        height: lastActionsView.heightSection

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.leftMargin: 16

        //background
        Rectangle
        {
            id: itemRect
            anchors.fill: parent
            anchors.topMargin: 20
            anchors.bottomMargin: 10
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
            opacity: 0.24
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
            color: currTheme.mainBlockShadowInner
            opacity: 0.33
            source: itemRect
        }


        Text
        {
            anchors.fill: parent
            anchors.topMargin: 21
            anchors.bottomMargin: 10
            anchors.leftMargin: 14
            anchors.rightMargin: 16
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignLeft
            color: currTheme.white
            text: logicExplorer.getDateString(payDate)
            font: mainFont.dapFont.medium12
        }
    }
}
