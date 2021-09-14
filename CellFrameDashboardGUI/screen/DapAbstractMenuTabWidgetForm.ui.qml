import QtQuick 2.9
import QtQuick.Window 2.9
import "qrc:/widgets"

DapMenuTabWidget
{
    dapMenuWidget:
        ListView
        {
            id: menuTab
            anchors.fill: parent
            delegate: itemMenuTabDelegate
            spacing: 3 * pt
            clip: true
            interactive: false
        }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
