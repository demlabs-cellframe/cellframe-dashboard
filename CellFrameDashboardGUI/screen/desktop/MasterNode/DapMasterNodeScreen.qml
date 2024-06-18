import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../controls"
import "../../"
import "qrc:/widgets"
import "parts"

Page
{
    property alias currentIndex: tabsView.currentIndex
    property string currentNetwork: ""
    property string currentStakeToken: "-"
    property string currentMainToken: "-"

    id: dapMasterNodeScreen

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    ListModel { id: networkTabsModel }



    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            Item
        {
            width: parent.width
            anchors.fill: parent

            ListView
            {
                id: tabsView
                width: parent.width
                height: 42
                orientation: ListView.Horizontal
                model: networkTabsModel
                interactive: false
                onCurrentIndexChanged:
                {
                    currentNetwork = networkTabsModel.get(currentIndex).net
                    nodeMasterModule.setCurrentNetwork(currentNetwork)
                }

                delegate:
                Item
                {
                    property int textWidth: tabName.implicitWidth
                    property int spacing: 24
                    property int iconWidth: isMaster ? masterNodeIcon.width + 4 : 0

                    width: textWidth + iconWidth + spacing * 2
                    height: 42

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: tabsView.currentIndex = index
                    }

                    Text
                    {
                        id: tabName
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: spacing
                        anchors.verticalCenter: parent.verticalCenter

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        color: tabsView.currentIndex === index ? currTheme.white : currTheme.gray
                        font: mainFont.dapFont.medium14
                        text: net

                        Behavior on color {ColorAnimation{duration: 200}}
                    }

                    Image
                    {
                        id: masterNodeIcon
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: spacing
                        source: "qrc:/Resources/" + pathTheme + "/icons/navigation/icon_master_node.svg"
                        mipmap: true
                        visible: isMaster
                    }
                }

                Rectangle
                {
                    anchors.top: parent.bottom
                    anchors.topMargin: -3
                    width: networkTabsModel.count > 0 ? tabsView.currentItem.width : 0
                    height: 2

                    radius: 8
                    x: networkTabsModel.count > 0 ? tabsView.currentItem.x : 0
                    color: currTheme.lime

                    Behavior on x {NumberAnimation{duration: 200}}
                    Behavior on width {NumberAnimation{duration: 200}}
                }
            }

            Item
            {
                id: screensContent
                width: parent.width
                anchors.fill: parent
                anchors.topMargin: tabsView.height
                visible: networkTabsModel.count > 0

                DapMainMasterNodeScreen
                {
                    id: baseScreen
                    visible: currentIndex < 0 ? false : !networkTabsModel.get(currentIndex).isMaster
                }

                DapMasterNodeInfoScreen
                {
                    id: masterNodeScreen
                    width: parent.width
                    visible: currentIndex < 0 ? false : networkTabsModel.get(currentIndex).isMaster
                }
            }
        }
    }

    Component.onCompleted:
    {
        updateNetworkTabs()
        updateTokens()
    }

    function updateTokens()
    {
        currentMainToken = nodeMasterModule.mainTokenName
        currentStakeToken = nodeMasterModule.stakeTokenName

        baseScreen.updateText()
    }

    function updateNetworkTabs()
    {
        var arr = JSON.parse(nodeMasterModule.networksList)
        networkTabsModel.clear()
        networkTabsModel.append(arr)

        if(nodeMasterModule.currentNetwork === "" && networkTabsModel.count)
        {
            var indexFound = -1
            for(var i=0; i<networkTabsModel.count; ++i)
            {
                if(networkTabsModel.get(i).isMaster)
                {
                    indexFound = i
                    break
                }
            }
            if(indexFound < 0) indexFound = 0
            tabsView.currentIndex = indexFound
        }

    }

    Connections
    {
        target: nodeMasterModule

        function onCurrentNetworkChanged()
        {
            updateTokens()
        }

        function onNetworksListChanged()
        {
            updateNetworkTabs()
        }
    }
}
