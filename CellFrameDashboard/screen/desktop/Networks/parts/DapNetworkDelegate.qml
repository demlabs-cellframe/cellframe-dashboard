import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3


Component
{
    Item
    {
        id:controlDelegate
        width: networkModel.count >= visible_count ?
                   networkList.width / visible_count :
                   networkList.width / networkModel.count
        height: 40

        Rectangle
        {
            anchors.centerIn: parent
            width: 295
            height: parent.height
            color: area.containsMouse? currTheme.rowHover : "transparent"

            MouseArea
            {
                id: area
                anchors.fill: parent
                hoverEnabled: true
            }

            DapNetworkNameStatusComponent
            {
                nameOfNetwork: networkName
                stateOfNetwork: networkState
                stateOfTarget: targetState
                percentOfSync: syncPercent
            }
        }

        DapInfoDelegate
        {
            id: info
            width: item_width
            height: app.getNodeMode() === 0 ? 190 : 190 - 32 //32 - height buttons and spacing
            x: 0
            y: 0
            scale: mainWindow.scale
            Component.onCompleted: setInfoPosition()
        }

        Connections
        {
            target: networkList
            function onClosePopups (){
                info.isOpen = false
                info.close()
            }
        }

        MouseArea {
            anchors.centerIn: parent
            width: 295
            height: parent.height

            onClicked: {
//                console.log("CLICK NET", info.y)
                if(info.isOpen)
                    info.close()
                else
                {
                    networkList.closePopups()
                    setInfoPosition()
                    info.open()
                }
                info.isOpen = !info.isOpen
//                console.log("CLICK NET", info.y)
            }
        }

        function setInfoPosition() {
            info.x = controlDelegate.width/2 - info.width/2/info.scale
            if (params.mainWindowScale < 1.0)
            {
                info.startY = controlDelegate.height + 2
                info.stopY = -info.height*(1 + 1/info.scale)*0.5 + controlDelegate.height + 2
//                print("setInfoPosition info.scale < 1.0")
            }
            else
            if (params.mainWindowScale === 1.0)
            {
                info.startY = controlDelegate.height + 2
                info.stopY = -info.height*(1 + 1/info.scale)*0.5 + controlDelegate.height + 2
//                print("setInfoPosition info.scale === 1.0")
            }
            else
            {
                info.startY = controlDelegate.height
                info.stopY = -info.height*(1 + 1/info.scale)*0.5 + controlDelegate.height
//                print("setInfoPosition info.scale >= 1.0")
            }
        }
    }


}
