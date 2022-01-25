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

    property int cur_index: 0
    readonly property int visible_count: 4
    readonly property int item_width: 295

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
            width: item_width
            height: 40
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
                    var coordInList = mapToItem(networkList, mouse.x, mouse.y)
                    var section_number = getSectionNumberForPopup(coordInList.x)

                    if (section_number >= 0) {
                        if (!networkListPopups[index].isOpen) {
                            closeAllPopups(networkListPopups, networkList.count)
                            control.updateContentInSpecifiedPopup(networkListPopups[index], networkList.model.get(index))

                            var idx = index
                            var cur_idx = networkList.currentIndex
                            networkListPopups[index].open()

                            var delta = networkList.width - 4*item_width
                            if (networkList.currentIndex > 2 && delta > 0) {
                                networkListPopups[index].x = delta + networkList.x+item_width*section_number+(item_width-networkListPopups[index].width)/2
                            } else {
                                networkListPopups[index].x = networkList.x+item_width*section_number+(item_width-networkListPopups[index].width)/2
                            }

                            networkListPopups[index].isOpen = true
                        } else {
                            networkListPopups[index].close()
                            networkListPopups[index].isOpen = false
                        }
                    } else {
                        if (networkList.currentIndex > 0) {
                            networkList.currentIndex -= 1

                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: left_button
        visible: networkList.count > 4
        width: parent.height
        radius: 50
        color: currTheme.backgroundPanel

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        DapImageLoader {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            innerHeight: 30 * pt
            innerWidth: 30 * pt
            source: "qrc:/resources/icons/previous_year_icon.png"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (networkList.currentIndex > 0) {
                    networkList.currentIndex -= 1
                    networksPanel.closeAllPopups(networkListPopups, networksModel.count)
                }
            }
        }
    }
    DropShadow {
        anchors.fill: left_button
        source: left_button
        color: currTheme.reflection
        horizontalOffset: -1
        verticalOffset: -1
        radius: 2
        samples: 0
        opacity: 1
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: left_button
        source: left_button
        color: currTheme.networkPanelShadow
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: 1
    }

    ListView {
        id: networkList
        model: networksModel
        highlightMoveDuration : 200

        orientation: ListView.Horizontal
        anchors.right: right_button.left
        anchors.left: left_button.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        delegate: dapNetworkItem
        focus: true
    }

    Rectangle {
        id: right_button
        visible: networkList.count > 4
        width: parent.height
        radius: 50
        color: currTheme.backgroundPanel

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        DapImageLoader {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            innerHeight: 30 * pt
            innerWidth: 30 * pt
            source: "qrc:/resources/icons/next-page.svg"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (networkList.currentIndex < networkList.count-1) {
                    networkList.currentIndex += 1
                    networksPanel.closeAllPopups(networkListPopups, networksModel.count)
                }
            }
        }
    }
    DropShadow {
        anchors.fill: right_button
        source: right_button
        color: currTheme.reflection
        horizontalOffset: -1
        verticalOffset: -1
        radius: 2
        samples: 0
        opacity: 1
        fast: true
        cached: true
    }
    DropShadow {
        anchors.fill: right_button
        source: right_button
        color: currTheme.networkPanelShadow
        horizontalOffset: 5
        verticalOffset: 5
        radius: 10
        samples: 20
        opacity: 1
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
        for (var i=0; i<networkList.count; ++i) {
            if (networkListPopups[i])
            {
                networkListPopups[i].x = networkList.x+item_width*i+(item_width-networkListPopups[i].width)/2
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
        for (var i=0; i<curModel.count; ++i) {
            if (popups[i] === 0 || typeof popups[i] === "undefined") {
                popups[i] = popupComponent.createObject(dapMainWindow, {"parent" : dapMainWindow})
                popups[i].x = networkList.x+item_width*i+(item_width-popups[i].width)/2
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
    function getSectionNumberForPopup(mouseX)
    {
        if (mouseX >= 0) {
            return Math.floor(mouseX / item_width)
        } else {
            return -1
        }
    }
}
