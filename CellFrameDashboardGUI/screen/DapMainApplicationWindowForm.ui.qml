import QtQuick 2.4
import "qrc:/"

DapMainWindowForm {
    anchors.fill: parent
    // Logo icon
    iconLogotype.source: "qrc:/res/icons/cellframe-logo-dashboard.png"
    // Menu bar width
    menuWidth: 180 * pt
    // Color of menu item in normal condition
    menuTabWidget.normalColorItemMenu: "transparent"
    // The color of the menu item in the selected state
    menuTabWidget.selectColorItemMenu: "#D51F5D"
    // Menu item icon width
    menuTabWidget.widthIconItemMenu: 18 * pt
    // Menu item icon height
    menuTabWidget.heightIconItemMenu: 18 * pt
    // Menu item height
    menuTabWidget.heightItemMenu: 60 * pt
    // Initialization of the menu bar
    menuTabWidget.viewMenuTab.model: modelMenuTab
    
    
    
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
