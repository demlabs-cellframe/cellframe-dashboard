import QtQuick 2.4
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "qrc:/"
import "../../"
//import DapNotificationWatcher 1.0

Rectangle
{    
    property alias dapNetworkList: networkList

    property int cur_index: 0
    property int visible_count: 4
    readonly property int item_width: 290 * pt

    id: control
    y: parent.height - height
    width: parent.width
    height: 40
    color: currTheme.backgroundPanel

//<<<<<<< HEAD
//=======
//    layer.enabled: true
//    layer.effect: DropShadow {
//        anchors.fill: control
//        radius: currTheme.radiusShadowSmall
//        color: currTheme.reflectionLight
//        source: control
//        spread: 0.7
//    }
//    Component.onCompleted:
//    {
//        dapServiceController.requestToService("DapGetNetworksStateCommand")
//    }

//>>>>>>> ad58c27b1072b9518c9ab46b926a13144720515f
    Timer {
        id: idNetworkPanelTimer
        interval: 3000; running: true; repeat: true
        onTriggered: dapServiceController.requestToService("DapGetNetworksStateCommand")
    }

    Rectangle
    {
        id: animationController
        visible: false

        SequentialAnimation {
            NumberAnimation {
                target: animationController
                properties: "opacity"
                from: 1.0
                to: 0.1
                duration: 700
            }

            NumberAnimation {
                target: animationController
                properties: "opacity"
                from: 0.1
                to: 1.0
                duration: 700
            }
            loops: Animation.Infinite
            running: true
        }
    }


    Component {
        id: dapNetworkItem

        Item {
//<<<<<<< HEAD
            id:controlDelegate
            width: networksModel.count >= visible_count ?
                       networkList.width / visible_count :
                       networkList.width / networksModel.count
//=======
//            id: controlDelegate
//            width: networksModel.count > visible_count -1 ? item_width : parent.parent.width/networksModel.count
//>>>>>>> ad58c27b1072b9518c9ab46b926a13144720515f
            height: 40
            objectName: "delegateList"
            property int list_index:index

            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.fill: parent
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

            NetworkInfoPopup
            {
                id:popup_
                width: item_width
                parentWidth: controlDelegate.width
                isOpen: false
                x: controlDelegate.width/2 - width/2/mainWindow.scale - 0.5
                y: -height*(1 + 1/mainWindow.scale)*0.5 + controlDelegate.height

                imgStatus.opacity: networkState !== targetState? animationController.opacity : 1

                scale: mainWindow.scale

                Component.onCompleted:
                {
                    if (params.mainWindowScale > 1.0)
                    {
                        x = controlDelegate.width/2 - width/2/mainWindow.scale
                        y = -height*(1 + 1/mainWindow.scale)*0.5 + controlDelegate.height
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(popup_.isOpen)
                        popup_.close()
                    else
                    {
                        networkList.closePopups()
                        popup_.open()
                    }
                    popup_.isOpen = !popup_.isOpen
                }
            }


            Connections
            {
                target: networkList
                onClosePopups:{
                    popup_.isOpen = false
                    popup_.close()
                }
            }
        }
    }

    DapNetworkPanelButton
    {
        id: left_button
        anchors.left: parent.left
        anchors.leftMargin: 7 * pt
        anchors.verticalCenter: parent.verticalCenter

        visible: networkList.count > visible_count && networkList.currentIndex != 0 ? true : false

        mirror: true

        onClicked:
        {
            if(networkList.currentIndex === networkList.count -1)
            {
                networkList.currentIndex = networkList.currentIndex - (visible_count - 1)
                networkList.isRight = false
            }

            if (networkList.currentIndex > 0) {
                if(networkList.isRight)
                    networkList.currentIndex = networkList.currentIndex - (visible_count - 1)

                var zero = 0;

                for(var i = visible_count-1; i > 0; i--)
                {
                    if(networkList.currentIndex - i >= zero )
                    {
                        networkList.currentIndex -= i
                        break;
                    }
                }
                networkList.closePopups()
            }
            networkList.isRight = false
        }
    }

    DapNetworkPanelButton
    {
        id: right_button
        anchors.right: parent.right
        anchors.rightMargin: 7 * pt

        anchors.verticalCenter: parent.verticalCenter
        visible: networkList.count > visible_count && networkList.currentIndex != networkList.count -1 ? true : false

        onClicked: {
            if(!networkList.currentIndex)
            {
                networkList.currentIndex = visible_count - 1
                networkList.isRight = true
            }

            if (networkList.currentIndex < networkList.count-1) {

                if(!networkList.isRight)
                    networkList.currentIndex = networkList.currentIndex + (visible_count - 1)


                for(var i = visible_count-1; i > 0; i--)
                {
                    if(networkList.currentIndex + i <= networkList.count -1)
                    {
                        networkList.currentIndex += i
                        break;
                    }
                }
                networkList.closePopups()
            }
            networkList.isRight = true
        }
    }

    ListView {
        signal closePopups()
        property bool isRight:true
        id: networkList
        model: networksModel
        highlightMoveDuration : 200

        orientation: ListView.Horizontal
        anchors.right: right_button.left
        anchors.left: left_button.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.leftMargin: 10 * pt
        anchors.rightMargin: 10 * pt
        delegate: dapNetworkItem
        interactive: false
        clip: true
    }

    ListModel {
        id: networksModel
    }

    onWidthChanged:
    {
        control.visible_count = getCountVisiblePopups()
        networkList.currentIndex = cur_index
        networkList.closePopups()
    }

    Connections
    {
        target: dapServiceController

        onSignalNetState:
        {
            notifyModelUpdate(netState)
        }
    }

    Connections
    {
        target: dapServiceController

        onNetworksStatesReceived:
        {
            if (!networksPanel.isNetworkListsEqual(networksModel, networksStatesList)) {
                networkList.closePopups()
            }
            networksPanel.modelUpdate(networksStatesList)
            networksPanel.updateContentInAllOpenedPopups(networksModel)
        }
    }


    function closeAllPopups(popups, count)
    {
        for (var i=0; i<count; ++i) {
            if (popups[i] !== 0 && typeof popups[i] !== "undefined" && popups[i].isOpen) {
                popups[i].isOpen = false
                popups[i].close()
            }
        }
    }

    function modelUpdate(networksStatesList)
    {
        if (!isNetworkListsEqual(networksModel, networksStatesList)) {

            networksModel.clear()
            for (var i = 0; i < networksStatesList.length; ++i)
            {
                networksModel.append({ "name" : networksStatesList[i].name,
                                                "networkState" : networksStatesList[i].networkState,
                                                "targetState" : networksStatesList[i].targetState,
                                                "errorMessage" : networksStatesList[i].errorMessage,
                                                "linksCount" : networksStatesList[i].linksCount,
                                                "activeLinksCount" : networksStatesList[i].activeLinksCount,
                                                "nodeAddress" : networksStatesList[i].nodeAddress})
            }
        } else {
            updateContentForExistingModel(networksModel, networksStatesList)
        }
    }

    function updateContentForExistingModel(curModel, newData)
    {
        if (isNetworkListsEqual(curModel, newData)) {
            for (var i=0; i<curModel.count; ++i) {
                if (curModel.get(i).name !== newData[i].name)
                    curModel.set(i, {"name": newData[i].name})
                if (curModel.get(i).networkState !== newData[i].networkState)
                    curModel.set(i, {"networkState": newData[i].networkState})
                if (curModel.get(i).targetState !== newData[i].targetState)
                    curModel.set(i, {"targetState": newData[i].targetState})
                if (curModel.get(i).errorMessage !== newData[i].errorMessage)
                    curModel.set(i, {"errorMessage": newData[i].errorMessage})
                if (curModel.get(i).linksCount !== newData[i].linksCount)
                    curModel.set(i, {"linksCount": newData[i].linksCount})
                if (curModel.get(i).activeLinksCount !== newData[i].activeLinksCount)
                    curModel.set(i, {"activeLinksCount": newData[i].activeLinksCount})
                if (curModel.get(i).nodeAddress !== newData[i].nodeAddress)
                    curModel.set(i, {"nodeAddress": newData[i].nodeAddress})
            }
        }
    }

    function updateContentInSpecifiedPopup(popup, curDataFromModel)
    {
        if (popup.name !== curDataFromModel.name)
            popup.name = curDataFromModel.name
        if (popup.networkState !== curDataFromModel.networkState)
            popup.networkState = curDataFromModel.networkState
        if (popup.errorMessage !== curDataFromModel.errorMessage)
            popup.errorMessage = curDataFromModel.errorMessage
        if (popup.targetState !== curDataFromModel.targetState)
            popup.targetState = curDataFromModel.targetState
        if (popup.linksCount !== curDataFromModel.linksCount)
            popup.linksCount = curDataFromModel.linksCount
        if (popup.activeLinksCount !== curDataFromModel.activeLinksCount)
            popup.activeLinksCount = curDataFromModel.activeLinksCount
        if (popup.nodeAddress !== curDataFromModel.nodeAddress)
            popup.nodeAddress = curDataFromModel.nodeAddress
    }

    function updateContentInAllOpenedPopups(curModel)
    {
        for (var i=0; i<curModel.count; ++i) {
            updateContentInSpecifiedPopup(networksModel.get(i), curModel.get(i))
        }
    }

    function isNetworkListsEqual(curModel, newData)
    {
        if (curModel.count === newData.length) {
            for (var i=0; i<curModel.count; ++i) {
                if (curModel.get(i).name !== newData[i].name) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }

    function getCountVisiblePopups()
    {
        var count = networkList.width/item_width
        return Math.floor(count)
    }

    function notifyModelUpdate(data)
    {
        if(networksModel.count)
        {
            for(var i = 0; i < networksModel.count; i++)
            {
                if(networksModel.get(i).name === data.name)
                {
                    networksModel.get(i).networkState = data.networkState.substr(10)
                    networksModel.get(i).targetState = data.targetState.substr(10)
                    networksModel.get(i).errorMessage = data.errorMessage
                    networksModel.get(i).linksCount = data.linksCount.toString()
                    networksModel.get(i).activeLinksCount = data.activeLinksCount.toString()
                    networksModel.get(i).nodeAddress = data.nodeAddress
                }
            }
        }
        else
        {
            networksModel.append({ "name" : data.name,
                                   "networkState" : data.networkState,
                                   "targetState" : data.targetState,
                                   "errorMessage" : data.errorMessage,
                                   "linksCount" : data.linksCount.toString(),
                                   "activeLinksCount" : data.activeLinksCount.toString(),
                                   "nodeAddress" : data.nodeAddress})
        }
    }
}
