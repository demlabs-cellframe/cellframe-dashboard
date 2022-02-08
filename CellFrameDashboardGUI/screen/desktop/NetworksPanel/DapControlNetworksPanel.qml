import QtQuick 2.4
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "qrc:/"
import "../../"

DapNetworksPanel
{    
    property alias dapNetworkList: networkList

    property int cur_index: 0
    property int visible_count: 4
    readonly property int item_width: 295 * pt

    id: control
    y: parent.height - height
    width: parent.width
    height: 40
    color: currTheme.backgroundPanel

    layer.enabled: true
    layer.effect: DropShadow {
        anchors.fill: control
        radius: currTheme.radiusShadowSmall
        color: currTheme.reflectionLight
        source: control
        spread: 0.7
    }

    Timer {
        id: idNetworkPanelTimer
        interval: 5000; running: true; repeat: true
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
            loops:Animation.Infinite
            running: true
        }
    }


    Component {
        id: dapNetworkItem

        Item {
            id:controlDelegate
            width: networksModel.count > visible_count -1 ? item_width : parent.parent.width/networksModel.count
            height: 40
            objectName: "delegateList"
            property int list_index:index

            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 5 * pt
                Text {
                    id: txt_left
                    Layout.fillWidth: true
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
                    color: currTheme.textColor
                    text: name
                }

                DapImageLoader{
                    id:img
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 8 * pt
                    Layout.preferredWidth: 8 * pt
                    innerWidth: 8 * pt
                    innerHeight: 8 * pt

                    source: networkState === "OFFLINE" ? "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png" :
                            networkState === "ERROR" ?   "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                         "qrc:/resources/icons/" + pathTheme + "/indicator_online.png"
                    opacity: networkState !== targetState? animationController.opacity : 1
                }
            }

            NetworkInfoPopup
            {
                id:popup_
                width: item_width
                parentWidth: controlDelegate.width
                isOpen: false
                y: -150
                x: controlDelegate.width/2 - popup_.width/2
                imgStatus.opacity: networkState !== targetState? animationController.opacity : 1
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
            if (networkList.currentIndex > 0) {

                var zero = 0;

                for(var i = visible_count; i > 0; i--)
                {
                    if(networkList.currentIndex - i >= zero )
                    {
                        networkList.currentIndex -= i
                        break;
                    }
                }
                networkList.closePopups()
            }
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
            if (networkList.currentIndex < networkList.count-1) {

                for(var i = visible_count; i > 0; i--)
                {
                    if(networkList.currentIndex + i <= networkList.count -1)
                    {
                        networkList.currentIndex += i
                        break;
                    }
                }
                networkList.closePopups()
            }
        }
    }

    ListView {
        signal closePopups()
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
                                                "stateColor" : networksStatesList[i].stateColor,
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
                if (curModel.get(i).stateColor !== newData[i].stateColor)
                    curModel.set(i, {"stateColor": newData[i].stateColor})
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
        if (popup.stateColor !== curDataFromModel.stateColor)
            popup.stateColor = curDataFromModel.stateColor
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
        var count = (control.parent.parent.width - 27 * pt/* - 114 * pt*/)/item_width
        return Math.floor(count)
    }
}
