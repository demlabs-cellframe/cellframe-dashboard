import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "qrc:/"
import "../../"

DapNetworksPanel
{    
    property alias dapNetworkList: networkList

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
        interval: 1000; running: true; repeat: true
        onTriggered: dapServiceController.requestToService("DapGetNetworksStateCommand")
    }

    Component {
        id: dapNetworkItem

        Item {
            width: parent.parent.width/networksModel.count; height: 40
//            border.width: 1
//            border.color: "green"
//            color: "transparent"
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: txt_left
                    Layout.fillWidth: true
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold12
                    color: currTheme.textColor
                    text: name
                }

                DapImageLoader{
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredHeight: 8 * pt
                    Layout.preferredWidth: 8 * pt
                    innerWidth: 8 * pt
                    innerHeight: 8 * pt

                    source: networkState === "OFFLINE" ? "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png" :
                            networkState === "ERROR" ?   "qrc:/resources/icons/" + pathTheme + "/indicator_error.png":
                                                         "qrc:/resources/icons/" + pathTheme + "/indicator_online.png"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    if (!networkListPopups[index].isOpen) {
                        control.updateContentInSpecifiedPopup(networkListPopups[index], networkList.model.get(index))
                        networkListPopups[index].open()
                        networkListPopups[index].isOpen = true
                    } else {
                        networkListPopups[index].close()
                        networkListPopups[index].isOpen = false
                    }
                }
            }
        }
    }

    ListView {
        id: networkList
        model: networksModel
        interactive: false
        orientation: ListView.Horizontal
        ScrollBar.horizontal: ScrollBar {
            active: true
        }

        anchors.fill: parent
        delegate: dapNetworkItem
        focus: true
    }

    ListModel
    {
        id:networkListPopups
    }

    ListModel {
        id: networksModel
    }

    onWidthChanged:
    {
        var widthItem = networkList.width / networkList.count
        for (var i=0; i<networkList.count; ++i) {
            if (networkListPopups[i])
            {
                networkListPopups[i].x = widthItem*i+(widthItem-networkListPopups[i].width)/2
            }
        }
    }
    Connections
    {
        target: dapServiceController

        onNetworksStatesReceived:
        {
            if (!networksPanel.isNetworkListsEqual(networksModel, networksStatesList)) {
                networksPanel.closeAllPopups(networkListPopups, networksModel.count)
            }

            networksPanel.modelUpdate(networksStatesList)
            networksPanel.recreatePopups(networksPanel.dapNetworkList.model, networkListPopups)
            networksPanel.updateContentInAllOpenedPopups(networkListPopups, networksModel)
        }
    }

    function recreatePopups(curModel, popups)
    {
        var popupComponent = Qt.createComponent("qrc:/screen/desktop/NetworksPanel/NetworkInfoPopup.qml")
        var widthItem = networkList.width / networkList.count
        for (var i=0; i<curModel.count; ++i) {
            if (popups[i] === 0 || typeof popups[i] === "undefined") {
                popups[i] = popupComponent.createObject(dapMainWindow, {"parent" : dapMainWindow})
                popups[i].x = widthItem*i+(widthItem-popups[i].width)/2
                popups[i].isOpen = false
            }
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
        if (popup.networkName !== curDataFromModel.name)
            popup.networkName = curDataFromModel.name
        if (popup.networkState !== curDataFromModel.networkState)
            popup.networkState = curDataFromModel.networkState
        if (popup.stateColor !== curDataFromModel.stateColor)
            popup.stateColor = curDataFromModel.stateColor
        if (popup.error !== curDataFromModel.errorMessage)
            popup.error = curDataFromModel.errorMessage
        if (popup.targetState !== curDataFromModel.targetState)
            popup.targetState = curDataFromModel.targetState
        if (popup.linksCount !== curDataFromModel.linksCount)
            popup.linksCount = curDataFromModel.linksCount
        if (popup.activeLinksCount !== curDataFromModel.activeLinksCount)
            popup.activeLinksCount = curDataFromModel.activeLinksCount
        if (popup.nodeAddress !== curDataFromModel.nodeAddress)
            popup.nodeAddress = curDataFromModel.nodeAddress
    }

    function updateContentInAllOpenedPopups(popups, curModel)
    {
        for (var i=0; i<curModel.count; ++i) {
            if (popups[i].isOpen) {
                updateContentInSpecifiedPopup(popups[i], curModel.get(i))
            }
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
}
