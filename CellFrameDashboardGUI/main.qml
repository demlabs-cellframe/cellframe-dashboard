import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.12
import "screen"

ApplicationWindow
{
    id: window
    visible: true
    width: 1280
    height: 800
    property variant networkListPopups : []

    //Main window
    DapMainApplicationWindow
    {
        id:mainWindow
        property alias device: dapDevice.device        

        anchors.fill: parent

        Device
        {
            id: dapDevice
        }
    }


    ///The image with the effect fast blur
    Image
    {
        id: screenShotMainWindow
        anchors.fill: parent
        smooth: true
        visible: false
    }
    // Fast bluer application
    FastBlur
    {
        id: fastBlurMainWindow
        anchors.fill: screenShotMainWindow
        source: screenShotMainWindow
        radius: 50
        visible: false
    }

    Connections
    {
        target: dapServiceController

        onClientActivated:
        {
            if(window.visibility === Window.Hidden)
            {
                window.show()
                window.raise()
                window.requestActivate()
            }
            else
            {
                window.hide()
            }
        }
    }

    Connections {
        target: systemTray
        onSignalShow: {
            window.show()
            window.raise()
            window.requestActivate()
        }

        onSignalQuit: {
            systemTray.hideIconTray()
            Qt.quit()
        }

        onSignalIconActivated: {
             if(window.visibility === Window.Hidden)
             {
                 window.show()
                 window.raise()
                 window.requestActivate()
             }
             else
             {
                 window.hide()
             }
        }
    }

    footer: Rectangle {
        id: networksPanel
        width: parent.width; height: 40
        color: "#070023"
        border.width: 1
        border.color: "grey"

        Component {
            id: dapNetworkItem

            Item {
                width: parent.parent.width/dapNetworkModel1.count; height: 40
                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id: txt_left
                        color: "white"
                        text: '<b>Name:</b> ' + networkName
                    }
                    Text {
                        anchors.left: txt_left.anchors.RightAnchor
                        text: '<font size="2" color="' + stateColor + '"> \u2B24</font>'
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        dapNetworkList.currentIndex = index
                        var popupComponent = Qt.createComponent("qrc:/NetworkInfoPopup.qml")

                        if (networkListPopups[index] === 0 || typeof networkListPopups[index] === "undefined") {
                            networkListPopups[index] = popupComponent.createObject(window, {"parent" : window})
                            networkListPopups[index].x = (dapNetworkList.width / dapNetworkList.count)*index

                            networkListPopups[index].networkState = dapNetworkList.model.get(index).networkState
                            networkListPopups[index].error = dapNetworkList.model.get(index).error
                            networkListPopups[index].targetState = dapNetworkList.model.get(index).targetState
                            networkListPopups[index].linksCount = dapNetworkList.model.get(index).linksCount
                            networkListPopups[index].linksFrom = dapNetworkList.model.get(index).linksFrom
                            networkListPopups[index].address = dapNetworkList.model.get(index).address

//                            networkListPopups[index].networkState = dapServiceController.CurrentWalletNetwork.
                            networkListPopups[index].open()
                        }
                        else {
                            networkListPopups[index].close()
                            networkListPopups[index] = 0
                        }
                    }
                }
            }
        }

        ListModel {
            id: dapNetworkModel1
            ListElement {
                networkName: "Cellnet"
                networkState: "ONLINE"
                stateColor: "green"
                error: ""
                targetState: "ONLINE"
                linksCount: 1
                linksFrom: 2
                address: "1234::0000::0001::0002"
            }
            ListElement {
                networkName: "Mainnet"
                networkState: "ESTABLISHING"
                stateColor: "green"
                error: ""
                targetState: "ONLINE"
                linksCount: 0
                linksFrom: 1
                address: "1234::0000::0001::0002"
            }
            ListElement {
                networkName: "Somenet"
                networkState: "DISCONNECTING"
                stateColor: "yellow"
                error: ""
                targetState: "OFFLINE"
                linksCount: 0
                linksFrom: 3
                address: "1234::0000::0001::0002"
            }
            ListElement {
                networkName: "Testnet"
                networkState: "ERROR"
                stateColor: "red"
                error: "Text ERROR"
                targetState: "ONLINE"
                linksCount: 1
                linksFrom: 2
                address: "1234::0000::0001::0002"
            }
        }

        ListView {
            id: dapNetworkList
            interactive: false
            orientation: ListView.Horizontal
            ScrollBar.horizontal: ScrollBar {
                active: true
            }

            anchors.fill: parent
            model: dapNetworkModel1
            delegate: dapNetworkItem
            focus: true
        }
    }

    onClosing: {
        close.accepted = false
        window.hide()
    }
}
