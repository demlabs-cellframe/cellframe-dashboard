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

    dapMainRowSpacing: 3 * pt
    dapMainColumnSpacing: 4 * pt

    dapLeftRectangleBackground:
        Rectangle
        {
            id: menuUnroundedBackground
            anchors.left: parent.left
            width: dapLeftMenuBackground.radius
            height: dapLeftMenuBackground.height
            color: "#211A3A"
        }
    dapLeftMenuBackground:
        Rectangle
        {
            id: menuRoundedBackground
            anchors.left: parent.left
            width: 180 * pt
            height: dapScreensWidget.height
            color: "#211A3A"
            radius: 8 * pt
        }


    dapLogotype:
        // Logotype
        Rectangle
        {
            id: frameLogotype
            anchors.fill: parent
            color: "transparent"
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

    dapScreensWidget:
        // Sceen loader
        Loader
        {
            id: stackViewTabs
            anchors.fill: parent
            clip: true
        }

    dapStatusBarWidget:
        Rectangle
        {
            id: statusBar
            //anchors.fill: parent
            color: "#211A3A"
            height: 40 * pt
            width: parent.width

        }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
