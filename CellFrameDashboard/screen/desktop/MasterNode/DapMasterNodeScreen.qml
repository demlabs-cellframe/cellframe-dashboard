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

    property string currentStakeToken: "-"
    property string currentMainToken: "-"

    id: dapMasterNodeScreen

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    ListModel { id: networkTabsModel }

    state: "DEFAULT_SCREEN"
    states: [
        State {
            name: "DEFAULT_SCREEN"
            PropertyChanges { target: baseScreen; visible: true }
            PropertyChanges { target: masterScrollView; visible: false }
        },
        State {
            name: "IS_MASTER_SCREEN"
            PropertyChanges { target: baseScreen; visible: false }
            PropertyChanges { target: masterScrollView; visible: true }
        }
    ]

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
            anchors.fill: parent
            visible: networkTabsModel.count > 0

            ListView
            {
                id: tabsView
                width: parent.width
                height: 42
                anchors.top: parent.top
                anchors.left: parent.left
                orientation: ListView.Horizontal
                model: networkTabsModel
                interactive: false
                onCurrentIndexChanged:
                {
                    tryStateChange()
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
                    id: tabsBottomline
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    color: currTheme.grid
                }

                Rectangle
                {
                    anchors.top: parent.bottom
                    anchors.topMargin: -3
                    width: networkTabsModel.count > 0 ? tabsView.currentItem.width : 0
                    height: 2

                    radius: 8
                    x: networkTabsModel.count > 0 ? tabsView.currentItem.x : 0
                    z: parent.z + 1
                    color: currTheme.lime

                    Behavior on x {NumberAnimation{duration: 200}}
                    Behavior on width {NumberAnimation{duration: 200}}
                }
            }

            // Default screen
            DapMainMasterNodeScreen
            {
                id: baseScreen
                anchors.top: tabsView.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }

            // is master node Screen
            ScrollView
            {
                id: masterScrollView
                anchors.fill: parent
                anchors.topMargin: tabsView.height
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                // ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                clip: true

                contentData:
                    ColumnLayout
                {
                    id: screensContent
                    width: parent.width
                    spacing: 0

                    DapIsMasterNodeScreen
                    {
                        id: masterNodeScreen
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                    }
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

        var i=0
        var indexFound = -1
        if(nodeMasterModule.currentNetwork === "" && networkTabsModel.count)
        {
            for(; i<networkTabsModel.count; ++i)
            {
                if(networkTabsModel.get(i).isMaster)
                {
                    indexFound = i
                    break
                }
            }
        }
        else if(networkTabsModel.count)
        {
            for(; i < networkTabsModel.count; ++i)
            {
                if(networkTabsModel.get(i).net === nodeMasterModule.currentNetwork)
                {
                    indexFound = i
                    break
                }
            }
        }
        if(networkTabsModel.count)
        {
            if(indexFound <= 0) indexFound = 0
            tabsView.currentIndex = indexFound
        }
        else
        {
            console.log("[MasterNodeScreen] Network mpdel is empty")
        }
    }

    function changeCurrentWallet(wallet)
    {
        if(wallet !== "") {
            walletModule.setCurrentWallet(wallet)
            walletModule.updateWalletList()
        }
    }

    function tryStateChange()
    {
        var currentIndex = tabsView.currentIndex
        nodeMasterModule.currentNetwork = networkTabsModel.get(currentIndex).net
        console.log("[MasterNodeScreen] new current network: ", nodeMasterModule.currentNetwork, ", index: ", currentIndex)
        var state = networkTabsModel.get(currentIndex).isMaster ? "IS_MASTER_SCREEN" : "DEFAULT_SCREEN"
        if(dapMasterNodeScreen.state !== state)
        {
            dapMasterNodeScreen.state = state
        }
    }

    Connections
    {
        target: nodeMasterModule

        function onCurrentNetworkChanged()
        {
            updateTokens()
            changeCurrentWallet(nodeMasterModule.currentWalletName)
        }

        function onNetworksListChanged()
        {
            updateNetworkTabs()
        }
        
        function onMasterNodeCreated()
        {
            tryStateChange()
        }
    }
}
