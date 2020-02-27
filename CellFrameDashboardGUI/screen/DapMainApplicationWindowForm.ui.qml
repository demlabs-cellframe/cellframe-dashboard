import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"

DapMainWindow
{
    anchors.fill: parent

    ///@detalis Logo icon.
    property alias dapIconLogotype: iconLogotype
    ///@detalis Logo frame.
    property alias dapFrameLogotype: frameLogotype
    ///@detalis Menu bar.
    property alias dapMenuTabWidget: menuTabWidget

    property alias dapScreenLoader: stackViewTabs

    dapLogotype:
        // Logotype
        Rectangle
        {
            id: frameLogotype
            anchors.fill: parent
            color: "#070023"
            height: 60 * pt
            Image 
            {
                id: iconLogotype
                anchors.verticalCenter: parent.verticalCenter
                width: 111 * pt
                height: 24 * pt
                anchors.left: parent.left
                anchors.leftMargin: 24 * pt
                source: "qrc:/resources/icons/cellframe-logo-dashboard.png"
            }
        }

    dapMenuWidget:
        // Menu bar
        DapAbstractMenuTabWidget
        {
            id: menuTabWidget
            anchors.fill: parent
            dapFrameMenuTab.width: 180 * pt
            heightItemMenu: 60 * pt
            normalColorItemMenu: "transparent"
            selectColorItemMenu: "#D51F5D"
            widthIconItemMenu: 18 * pt
            heightIconItemMenu: 18 * pt
            dapMenuWidget.model: modelMenuTab
        }

    dabScreensWidget:
        // Sceen loader
        Loader
        {
            id: stackViewTabs
            anchors.fill: parent
            clip: true
        }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
