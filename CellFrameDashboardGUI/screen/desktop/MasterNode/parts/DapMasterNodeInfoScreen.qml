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
    id: root
    width: parent.width
    anchors.fill: parent

    QMLClipboard{
        id: clipboard
    }

    ScrollView
    {
        property bool baseInfoShow: true

        id: scrollView
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        //ScrollBar.vertical.policy: contentHeight < dapMasterNodeScreen.height  - tabsView.header ? ScrollBar.AlwaysOff : ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        contentData:
            ColumnLayout
        {
            id: layout
            width: scrollView.width
            spacing: 0

            // BASE - HEADER
            Rectangle
            {
                id: baseInfoHeader
                height: 40
                Layout.fillWidth: true
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
                        onCopyClicked: {
                            clipboard.setText(getKeyValueText())
                        }
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
                        rotation: scrollView.baseInfoShow ? 180 : 0
                        source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                        mipmap: true

                        Behavior on rotation {NumberAnimation{duration: 200}}
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            scrollView.baseInfoShow = !scrollView.baseInfoShow
                        }
                    }
                }
            }

            // BASE - INFO
            Item
            {
                id: baseInfoRect
                height: baseInfoView.contentHeight
                Layout.fillWidth: true

                ListView
                {
                    id: baseInfoView
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    clip: true
                    model: nodeInfoModel
                    visible: scrollView.baseInfoShow
                    interactive: false

                    delegate:
                        Item
                    {
                        property int valueWidth: baseInfoItem.width - keyText.width - 16

                        id: baseInfoItem
                        width: parent.width
                        implicitHeight: Math.max(keyText.contentHeight, valueText.contentHeight)

                        Text
                        {
                            id: keyText
                            width: 140
                            anchors.left: parent.left
                            anchors.top: parent.top
                            font: mainFont.dapFont.regular14
                            color: currTheme.gray
                            text: key
                            wrapMode: Text.WordWrap
                        }

                        Text
                        {
                            id: valueText
                            width: copy ? valueWidth - copyIcon.width - 8 : valueWidth
                            anchors.left: keyText.right
                            //anchors.right: icon.left
                            anchors.top: parent.top
                            anchors.leftMargin: 16
                            //anchors.rightMargin: copy ? 8 : 0
                            font: mainFont.dapFont.regular14
                            color: currTheme.white
                            text: value
                            wrapMode: Text.Wrap
                        }



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
                                anchors.centerIn: parent
                                popupText: qsTr("Value copied")
                                onCopyClicked: {
                                    clipboard.setText(valueText.text)
                                }
                            }
                        }

                    }
                }
            }

            // SECOND - HEADER (tabs)
            Rectangle
            {
                id: secondInfoHedaer
                height: 42
                Layout.fillWidth: true
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
                        //TODO
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

            // SECOND - INFO
            Item
            {
                id: secondInfoRect
                height: secondInfoView.contentHeight
                Layout.fillWidth: true

                ListView
                {
                    id: secondInfoView
                    height: contentHeight
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    clip: true
                    model: validateInfoModel
                    interactive: false

                    delegate:
                        Item
                    {
                        id: secondInfoItem
                        width: parent.width
                        implicitHeight: Math.max(keyText2.contentHeight, keyText2.contentHeight)

                        Text
                        {
                            id: keyText2
                            width: 140
                            anchors.left: parent.left
                            anchors.top: parent.top
                            font: mainFont.dapFont.regular14
                            color: currTheme.gray
                            text: key
                            wrapMode: Text.WordWrap
                        }

                        Text
                        {
                            id: valueText2

                            width: secondInfoItem.width - keyText2.width - 16
                            anchors.left: keyText2.right
                            anchors.right: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 16
                            anchors.rightMargin: 8
                            font: mainFont.dapFont.regular14
                            color: currTheme.white
                            text: value
                            wrapMode: Text.Wrap
                        }
                    }
                }

            }

        }
    }




    ListModel
    {
        id: nodeInfoModel

        ListElement
        {
            key: qsTr("Public key:")
            value: "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2"
            copy: true
        }
        ListElement
        {
            key: qsTr("Node address:")
            value: "8343::1E4B::428B::101A"
            copy: false
        }
        ListElement
        {
            key: qsTr("Node IP:")
            value: "127.0.0.1"
            copy: false
        }
        ListElement
        {
            key: qsTr("Node port:")
            value: "8079"
            copy: false
        }
        ListElement
        {
            key: qsTr("Stake amount:")
            value: "22.0921931283 mCELL"
            copy: false
        }
        ListElement
        {
            key: qsTr("Transaction hash of stake:")
            value: "0xF01C34E60F4BF387EBC07451F988BA07EB8EAAE9B184870A16BF495E53523764"
            copy: true
        }
        ListElement
        {
            key: qsTr("Wallet name:")
            value: "MainWallet"
            copy: false
        }
        ListElement
        {
            key: qsTr("Wallet address:")
            value: "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2"
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
        ListElement
        {
            name: "VPN"
        }
        ListElement
        {
            name: "DEX"
        }
    }

    ListModel
    {
        id: validateInfoModel

        ListElement
        {
            key: qsTr("Availability of order:")
            value: "true"
        }
        ListElement
        {
            key: qsTr("Node presence in list:")
            value: "true"
        }
        ListElement
        {
            key: qsTr("Node weight:")
            value: "18.21239088%"
        }
        ListElement
        {
            key: qsTr("Node status:")
            value: "active"
        }
        ListElement
        {
            key: qsTr("Blocks signed:")
            value: "1249"
        }
        ListElement
        {
            key: qsTr("Total Rewards:")
            value: "0.45 CELL"
        }
        ListElement
        {
            key: qsTr("Total Blocks in the Network:")
            value: "8042"
        }
    }

    function getKeyValueText()
    {
        var text = "";
        for(var i=0; i<nodeInfoModel.count;i++)
        {
            text += nodeInfoModel.get(i).key + nodeInfoModel.get(i).value + "\n"
        }
        return text
    }
}
