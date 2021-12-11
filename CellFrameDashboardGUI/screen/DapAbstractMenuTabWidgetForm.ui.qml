import QtQuick 2.9
import QtQuick.Window 2.2
import "qrc:/widgets"

DapMenuTabWidget
{

    dapMenuWidget:
        ListView
        {
            id: menuTab
            anchors.fill: parent
            delegate: itemMenuTabDelegate
//            spacing: 3 * pt
            clip: true
            interactive: false
        }
    color: currTheme.backgroundPanel

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
