import QtQuick 2.4
import "qrc:/"

DapMainWindowForm {
    anchors.fill: parent
    // Logo icon
    dapIconLogotype.source: "qrc:/res/icons/cellframe-logo-dashboard.png"
    // Menu bar width
    dapMenuWidth: 180 * pt
    // Color of menu item in normal condition
    dapMenuTabWidget.normalColorItemMenu: "transparent"
    // The color of the menu item in the selected state
    dapMenuTabWidget.selectColorItemMenu: "#D51F5D"
    // Menu item icon width
    dapMenuTabWidget.widthIconItemMenu: 18 * pt
    // Menu item icon height
    dapMenuTabWidget.heightIconItemMenu: 18 * pt
    // Menu item height
    dapMenuTabWidget.heightItemMenu: 60 * pt
    // Initialization of the menu bar
    dapMenuTabWidget.dapMenuTab.model: modelMenuTab
    
    
    
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
