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

        RowLayout {
            id:content
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5 * pt

            Item {
                Layout.fillWidth: true
            }

            Text {
                id: txt_left
                Layout.fillWidth: true
                Layout.maximumWidth: item_width/2
                font: mainFont.dapFont.bold12
                color: currTheme.textColor
                elide: Text.ElideMiddle

                text: name
            }

            Image{
                id:img
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 8 * pt
                Layout.preferredWidth: 8 * pt
                width: 8 * pt
                height: 8 * pt
                mipmap: true

                source: networkState === "ONLINE" ? "qrc:/resources/icons/" + pathTheme + "/indicator_online.png" :
                        networkState === "ERROR" ?   "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                     "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png"

                opacity: networkState !== targetState? animationController.opacity : 1
            }

            Item {
                Layout.fillWidth: true
            }
        }

        DapInfoDelegate
        {
            id: info
            width: item_width
            height: 190

            x: 0
            y: 0

            imgStatus.opacity: networkState !== targetState? animationController.opacity : 1

            scale: mainWindow.scale

            Component.onCompleted:
            {
                setInfoPosition()
            }
        }

        Connections
        {
            target: networkList
            onClosePopups:{
                info.isOpen = false
                info.close()
            }
        }

        MouseArea {
            anchors.fill: parent
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
