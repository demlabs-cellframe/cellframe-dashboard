import QtQuick 2.4
import QtQuick.Controls 2.0
import "qrc:/widgets"


DapRightPanel
{
    id: rightPanel

    ///@detalis Stack of right panels owned by current.
    property alias dapChildRightPanels: childRightPanels
    
    dapHeader.height: 30 * pt
    dapFrame.width: 350 * pt
    dapFrame.height: parent.height
    color: "blue"


    dapHeaderData:
        Rectangle
        {
            anchors.fill: parent
            color: "yellow"
        }
    
    dapContentItemData:
        // Install right panel content
        StackView
        {
            id: childRightPanels
            anchors.fill: parent
        }
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
