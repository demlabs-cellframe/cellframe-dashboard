import QtQuick 2.4
import "qrc:/"
import QtQuick.Controls 2.0

DapRightPanelForm
{
    header.height: 30 * pt
    headerData: Rectangle
    {
        anchors.fill: parent
        color: "green"
    }
    
    contentItemPanel: Label
    {
        text: "HELLO!!!"
        font.pointSize: 30
        anchors.fill: parent
    }

    rightPanel.height: parent.height
    rightPanel.width: 350 * pt
    color: "blue"
}



/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
