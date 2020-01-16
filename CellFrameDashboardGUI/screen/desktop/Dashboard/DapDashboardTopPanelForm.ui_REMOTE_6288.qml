import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"

DapAbstractTopPanel
{
    property alias testButton: button
    Button
    {
        id: button
        anchors.fill: parent
        text: "Press"
    }

}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
