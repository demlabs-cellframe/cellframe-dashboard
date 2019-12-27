import QtQuick 2.4
import QtQuick.Controls 2.0
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

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
