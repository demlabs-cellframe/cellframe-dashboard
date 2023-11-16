import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3


Component {

    Item{

        id:controlDelegate
        width: networksModel.count >= visible_count ?
                   networkList.width / visible_count :
                   networkList.width / networksModel.count
        height: 40


        Rectangle{
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

            RowLayout {
                id:content
                anchors.centerIn: parent
                spacing: 5

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: txt_left
                    Layout.fillWidth: true
                    Layout.maximumWidth: item_width/2
                    font: mainFont.dapFont.bold12
                    color: currTheme.white
                    elide: Text.ElideMiddle

                    text: name
                }

                Image{
                    id:img
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 8
                    Layout.preferredWidth: 8
                    width: 8
                    height: 8
                    mipmap: true

                    source: networkState === "ONLINE" ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png" :
                            networkState !== targetState ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png" :
                            networkState === "ERROR" ?  "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.png":
                                                        "qrc:/Resources/" + pathTheme + "/icons/other/indicator_offline.png"

                    opacity: networkState !== targetState? animationController.opacity : 1
                }

                Item {
                    Layout.fillWidth: true
                }
            }

        }



        DapInfoDelegate
        {
            id: info
            width: item_width
            height: 190
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
