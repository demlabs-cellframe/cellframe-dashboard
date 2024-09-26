import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

Item
{
    id: mainItem

    property string networkFullName: ""
    property string networkRole: ""

    property bool node: true
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    signal confirm()

    ListModel
    {
        id: nodeRole
        ListElement{
            name: qsTr("Full")
            value: "full" }
        ListElement{
            name: qsTr("Light")
            value: "light" }
        ListElement{
            name: qsTr("Master")
            value: "master" }
        ListElement{
            name: qsTr("Archive")
            value: "archive" }
        ListElement{
            name: qsTr("Root")
            value: "root" }
    }

    onNetworkRoleChanged:
    {
        comboBoxNodeRole.setCurrentIndex(0)

        for (var i = 0; i < nodeRole.count; ++i)
        {
            if (nodeRole.get(i).value === networkRole)
                comboBoxNodeRole.setCurrentIndex(i)
        }
    }

    Page
    {
        id: page

        x: 0
        y: dapMainWindow.height + height
        width: dapMainWindow.width
        height: 460

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onVisibleChanged:
        {
            if (visible)
                y = dapMainWindow.height - height
            else
                y = dapMainWindow.height + height
        }

        background: Rectangle {
            color: currTheme.mainBackground
            radius: 30
            border.width: 1
            border.color: currTheme.border
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16

            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.bold14
            color: currTheme.white

            text: networkFullName + qsTr(" node role")
        }

        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            z: 1

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"
            mipmap: true

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    dapBottomPopup.hide()
                }
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 35
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            spacing: 10

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 20

                text: networkFullName + qsTr(" node role")
                color: currTheme.gray
                font: mainFont.dapFont.regular12

                verticalAlignment: Text.AlignVCenter
            }

            DefaultComboBox
            {
                id: comboBoxNodeRole
                Layout.fillWidth: true
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
                z: 100

                model: nodeRole
                rightMarginIndicator: 4

                font: mainFont.dapFont.regular16

//                defaultText: qsTr("Full")
            }

            Text
            {
                Layout.fillWidth: true

                text: qsTr(
"Full — Sync all its cell\n
Light — Synchronize only local wallets\n
Master — Allow to store values in chains and take commission, sync all shards that will need to be synced\n
Archive — sync all the network\n
Root — special predefined root nodes, usually produces zerochain and acts like archive as well")
                color: currTheme.gray
                font: mainFont.dapFont.regular13

                wrapMode: Text.WordWrap

                verticalAlignment: Text.AlignVCenter
            }


            DapButton
            {
        //        enabled: false
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 15
                implicitHeight: 36
                implicitWidth: 132
                textButton: qsTr("Confirm")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                onClicked:
                {
                    var value = ""

                    if (comboBoxNodeRole.currentIndex < nodeRole.count &&
                        comboBoxNodeRole.currentIndex >= 0)
                        value = nodeRole.get(comboBoxNodeRole.currentIndex).value

                    console.log("ComboBoxPopupItem", groupName, valueName, value)

                    if (node)
                        configWorker.writeNodeValue(
                            groupName, valueName, value)
                    else
                        configWorker.writeConfigValue(networkName,
                            groupName, valueName, value)

                    dapBottomPopup.hide()

                    mainItem.confirm()
                }
            }

            Item
            {
                Layout.fillHeight: true
            }
        }

    }

}

