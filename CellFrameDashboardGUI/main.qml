import QtQuick 2.0
import QtQuick.Controls 2.0
import "screen"

ApplicationWindow
{
    id: window
    visible: true
    width: 1280
    height: 800
    
    DapMainApplicationWindow
    {
        property alias device: dapDevice.device

        anchors.fill: parent

        Device
        {
          id: dapDevice
        }
    }
}
