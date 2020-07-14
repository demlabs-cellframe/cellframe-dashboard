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

    property alias dapStatusIndicator1: statusIndicator1

    dapMainRowSpacing: 3 * pt
    dapMainColumnSpacing: 4 * pt

    dapLeftRectangleBackground:
        Rectangle
        {
            id: menuUnroundedBackground
            anchors.fill: parent
            //anchors.left: parent.left
            width: dapLeftMenuBackground.radius
            height: dapLeftMenuBackground.height
            color: "#211A3A"
        }
    dapLeftMenuBackground:
        Rectangle
        {
            id: menuRoundedBackground
            anchors.fill: parent
            //anchors.left: parent.left
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
            color: "#211A3A"
            height: 40 * pt
            width: parent.width

            DapStatus
            {
                id: statusIndicator1
                width: 295 * pt
                height: statusBar.height
                anchors.left: parent.left
                anchors.leftMargin: 55 * pt
                anchors.verticalCenter: parent.verticalCenter
                dapStatusText: "Network name 1"
                dapStatusTextFont: dapMainFonts0.dapMainFontTheme.dapFontQuicksandMedium12
                dapStatusTextColor: "#FFFFFF"
                dapStatusSpacing: 8 * pt
                dapStatusIndicatorWidth:  8 * pt
                dapStatusIndicatorHeight: 8 * pt
                dapStatusIndicatorRadius: 8 * pt
                dapStatusIndicatorColor: "#9DD51F"
                dapStatusBackgroundColor: "transparent"
            }
            DapStatus
            {
                id: statusIndicator2
                width: 295 * pt
                height: statusBar.height
                anchors.left: statusIndicator1.right
                anchors.verticalCenter: parent.verticalCenter
                dapStatusText: "Network name 2"
                dapStatusTextFont: dapMainFonts0.dapMainFontTheme.dapFontQuicksandMedium12
                dapStatusTextColor: "#FFFFFF"
                dapStatusSpacing: 8 * pt
                dapStatusIndicatorWidth:  8 * pt
                dapStatusIndicatorHeight: 8 * pt
                dapStatusIndicatorRadius: 8 * pt
                dapStatusIndicatorColor: "#9DD51F"
                dapStatusBackgroundColor: "transparent"
            }
            DapStatus
            {
                id: statusIndicator3
                width: 295 * pt
                height: statusBar.height
                anchors.left: statusIndicator2.right
                anchors.verticalCenter: parent.verticalCenter
                dapStatusText: "Network name 3"
                dapStatusTextFont: dapMainFonts0.dapMainFontTheme.dapFontQuicksandMedium12
                dapStatusTextColor: "#FFFFFF"
                dapStatusSpacing: 8 * pt
                dapStatusIndicatorWidth:  8 * pt
                dapStatusIndicatorHeight: 8 * pt
                dapStatusIndicatorRadius: 8 * pt
                dapStatusIndicatorColor: "#9DD51F"
                dapStatusBackgroundColor: "transparent"
            }

            DapStatus
            {
                id: statusIndicator4
                width: 295 * pt
                height: statusBar.height
                anchors.left: statusIndicator3.right
                anchors.verticalCenter: parent.verticalCenter
                dapStatusText: "Network name 4"
                dapStatusTextFont: dapMainFonts0.dapMainFontTheme.dapFontQuicksandMedium12
                dapStatusTextColor: "#FFFFFF"
                dapStatusSpacing: 8 * pt
                dapStatusIndicatorWidth:  8 * pt
                dapStatusIndicatorHeight: 8 * pt
                dapStatusIndicatorRadius: 8 * pt
                dapStatusIndicatorColor: "#9DD51F"
                dapStatusBackgroundColor: "transparent"
            }
            DapButton
            {
                id: nextButtonStatusBar
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: statusBar.height
                height: statusBar.height
                textButton: ">>"
                colorBackgroundNormal: statusBar.color
                colorBackgroundHover: statusBar.color
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                horizontalAligmentText: Qt.AlignCenter
            }



        }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
