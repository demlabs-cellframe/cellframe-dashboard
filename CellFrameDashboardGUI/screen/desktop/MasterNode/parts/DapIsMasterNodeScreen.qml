import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import qmlclipboard 1.0
import "qrc:/widgets"
import "../../"
import "qrc:/"

Item
{
    property int textMargins: 16
    property bool baseInfoShow: true

    id: root
    height: baseInfoHeader.height + baseInfoBody.height + secondInfoHeader.height + secondInfoBody.height + textMargins*6

    QMLClipboard{
        id: clipboard
    }

    // BASE - HEADER
    Rectangle
    {
        id: baseInfoHeader
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        color: currTheme.mainBackground

        Text
        {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 16
            font: mainFont.dapFont.medium13
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Master Node")
        }

        Text
        {
            anchors.right: copyBtn_all.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 4
            font: mainFont.dapFont.regular12
            color: currTheme.gray
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            text: qsTr("Copy node info")
        }

        Item
        {
            id: copyBtn_all
            width: 16
            height: 16
            anchors.right: hideBtn.left
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            DapCopyButton
            {

                anchors.centerIn: parent
                popupText: qsTr("Value copied")
                onCopyClicked: copyFullNodeData()
            }
        }

        Item
        {
            id: hideBtn
            width: 24
            height: 24
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            Image
            {
                anchors.fill: parent
                rotation: root.baseInfoShow ? 180 : 0
                source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                mipmap: true

                Behavior on rotation {NumberAnimation{duration: 200}}
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    root.baseInfoShow = !root.baseInfoShow
                }
            }
        }
    }

    // BASE - BODY
    ListView
    {
        id: baseInfoBody
        height: root.baseInfoShow ? contentHeight : -textMargins*2
        anchors.top: baseInfoHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: textMargins
        spacing: textMargins
        clip: true
        model: nodeInfoModel
        interactive: false
        visible: root.baseInfoShow

        delegate:
            Item
        {
            id: baseInfoItem
            width: parent.width
            height: Math.max(keyText.contentHeight, valueText.contentHeight)

            Text
            {
                id: keyText
                width: 140
                anchors.left: parent.left
                anchors.top: parent.top
                font: mainFont.dapFont.regular14
                color: currTheme.gray
                wrapMode: Text.WordWrap
                text: displayKey
            }

            Text
            {
                id: valueText
                anchors.left: keyText.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: textMargins
                anchors.rightMargin: 8  + rightAdditional.width
                font: mainFont.dapFont.regular14
                color: currTheme.white
                wrapMode: Text.Wrap
                text: {
                    var text = nodeMasterModule.getMasterNodeDataByNetwork(nodeMasterModule.currentNetwork, key)
                    if(addKey)
                    {
                        text = text + " " + nodeMasterModule.getMasterNodeDataByNetwork(nodeMasterModule.currentNetwork, addKey)
                    }
                    return text
                }
            }

            Item
            {
                id: rightAdditional
                width: copyIcon.visible ? copyIcon.width : unlockItem.visible ? unlockItem.width : 0
                height: 20
                anchors.top: parent.top
                anchors.right: parent.right

                Item
                {
                    id: copyIcon
                    width: 20
                    height: 20
                    anchors.top: parent.top
                    anchors.right: parent.right
                    visible: copy

                    DapCopyButton
                    {
                        anchors.fill: parent
                        width: 20
                        height: 20
                        popupText: qsTr("Value copied")
                        onCopyClicked: {
                            clipboard.setText(valueText.text)
                        }
                    }
                }

                Item
                {
                    property string statusProtected: walletModelList.get(walletModule.currentWalletIndex).statusProtected

                    id: unlockItem
                    width: 20 + unlockText.contentWidth + 2
                    height: 20
                    anchors.top: parent.top
                    anchors.right: parent.right
                    visible: key == "walletName" && unlockItem.statusProtected !== ""

                    Image
                    {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        width: 20
                        height: 20
                        source: unlockItem.statusProtected === "non-Active" ?
                                    (unlockArea.containsMouse ? "qrc:/Resources/" + pathTheme + "/icons/other/lock_hover_20.svg" : "qrc:/Resources/" + pathTheme + "/icons/other/lock_20.svg")
                                  : (unlockArea.containsMouse ? "qrc:/Resources/" + pathTheme + "/icons/other/unlock_hover_20.svg" : "qrc:/Resources/" + pathTheme + "/icons/other/unlock_20.svg")
                        mipmap: true
                    }

                    Text
                    {
                        id: unlockText
                        anchors.right: parent.right
                        anchors.top: parent.top
                        font: mainFont.dapFont.regular14
                        color: unlockArea.containsMouse ? currTheme.orange : currTheme.lime
                        text: unlockItem.statusProtected === "non-Active" ? qsTr("Unlock") : qsTr("Lock")
                    }

                    MouseArea
                    {
                        id: unlockArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:
                        {
                            if(unlockItem.statusProtected === "non-Active")
                            {
                                walletActivatePopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName, false)
                            }
                            else
                            {
                                walletDeactivatePopup.show(walletModelList.get(walletModule.currentWalletIndex).walletName)
                            }
                        }
                    }

                    Connections
                    {
                        target: walletModule

                        function onListWalletChanged()
                        {
                            unlockItem.statusProtected = walletModelList.get(walletModule.currentWalletIndex).statusProtected
                        }
                    }
                }
            }
        }

        Behavior on height {NumberAnimation{duration: 100}}
    }

    // SECOND - HEADER (tabs)
    Rectangle
    {
        id: secondInfoHeader
        visible: false
        height: 0// 42
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: baseInfoBody.bottom
        anchors.topMargin: 16
        color: currTheme.mainBackground


        ListView
        {
            id: servicesTabsView
            anchors.fill: parent
            orientation: ListView.Horizontal
            model: servicesTabModel
            interactive: false

            onCurrentIndexChanged:
            {
                switch(currentIndex)
                {
                case 0: // Validator
                    secondInfoBody.model = validatorInfoModel
                    break
                // case 1: // VPN
                //     secondInfoView.model = null
                //     break
                // case 2: // DEX
                //     secondInfoView.model = null
                //     break
                }
            }

            delegate:
                Item
            {
                property int textWidth: serviceNameTab.implicitWidth
                property int spacing: 24

                width: textWidth + spacing * 2
                height: 42

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: servicesTabsView.currentIndex = index
                }

                Text
                {
                    id: serviceNameTab
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: spacing
                    anchors.verticalCenter: parent.verticalCenter

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: servicesTabsView.currentIndex === index ? currTheme.white : currTheme.gray
                    font: mainFont.dapFont.medium14
                    text: name

                    Behavior on color {ColorAnimation{duration: 200}}
                }
            }

            Rectangle
            {
                anchors.top: parent.bottom
                anchors.topMargin: -3
                width: servicesTabsView.currentItem.width
                height: 2

                radius: 8
                x: servicesTabsView.currentItem.x
                color: currTheme.lime

                Behavior on x {NumberAnimation{duration: 200}}
                Behavior on width {NumberAnimation{duration: 200}}
            }
        }
    }

    // SECOND - BODY
    ListView
    {
        id: secondInfoBody
        visible: false
        height: 0//contentHeight
        anchors.top: secondInfoHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: textMargins
        spacing: textMargins
        clip: true
        model: validatorInfoModel
        interactive: false

        delegate:
            Item
        {
            id: secondInfoItem
            width: parent.width
            height: Math.max(keyText2.contentHeight, keyText2.contentHeight)

            Text
            {
                id: keyText2
                width: 140
                anchors.left: parent.left
                anchors.top: parent.top
                font: mainFont.dapFont.regular14
                color: currTheme.gray
                text: displayKey
                wrapMode: Text.WordWrap
            }

            Text
            {
                id: valueText2
                anchors.left: keyText2.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: textMargins
                font: mainFont.dapFont.regular14
                color: currTheme.white
                text: nodeMasterModule.validatorData[key]
                wrapMode: Text.Wrap
            }
        }
    }

    ListModel
    {
        id: nodeInfoModel

        ListElement
        {
            key: "certHash"
            displayKey: qsTr("Public key:")
            copy: true
        }
        ListElement
        {
            key: "nodeAddress"
            displayKey: qsTr("Node address:")
            copy: false
        }
        ListElement
        {
            key: "nodeIP"
            displayKey: qsTr("Node IP:")
            copy: false
        }
        ListElement
        {
            key: "port"
            displayKey: qsTr("Node port:")
            copy: false
        }
        ListElement
        {
            key: "stakeValue"
            addKey: "stakeToken"
            displayKey: qsTr("Stake amount:")
            copy: false
        }
        ListElement
        {
            key: "stakeHash"
            displayKey: qsTr("Transaction hash of stake:")
            copy: true
        }
        ListElement
        {
            key: "walletName"
            displayKey: qsTr("Wallet name:")
            copy: false
        }
        ListElement
        {
            key: "walletAddress"
            displayKey: qsTr("Wallet address:")
            copy: true
        }
    }

    ListModel
    {
        id: servicesTabModel
        ListElement
        {
            name: "Validator"
        }
        // ListElement
        // {
        //     name: "VPN"
        // }
        // ListElement
        // {
        //     name: "DEX"
        // }
    }

    ListModel
    {
        id: validatorInfoModel

        ListElement
        {
            key: "availabilityOrder"
            displayKey: qsTr("Availability of order:")
        }
        ListElement
        {
            key: "nodePresence"
            displayKey: qsTr("Node presence in list:")
        }
        ListElement
        {
            key: "nodeWeight"
            displayKey: qsTr("Node weight:")
        }
        ListElement
        {
            key: "nodeStatus"
            displayKey: qsTr("Node status:")
        }
        ListElement
        {
            key: "blocksSigned"
            displayKey: qsTr("Blocks signed:")
        }
        ListElement
        {
            key: "totalRewards"
            displayKey: qsTr("Total Rewards:")
        }
        ListElement
        {
            key: "networksBlocks"
            displayKey: qsTr("Total Blocks in the Network:")
        }
    }

    function copyFullNodeData()
    {
        var text = "";
        for(var i=0; i<nodeInfoModel.count;i++)
        {
            var key = nodeInfoModel.get(i).key
            var addKey = nodeInfoModel.get(i).addKey
            text += nodeInfoModel.get(i).displayKey + nodeMasterModule.getMasterNodeDataByNetwork(nodeMasterModule.currentNetwork, key)
                  + " " + nodeMasterModule.getMasterNodeDataByNetwork(nodeMasterModule.currentNetwork, addKey) + "\n"
        }
        clipboard.setText(text)
    }
}
