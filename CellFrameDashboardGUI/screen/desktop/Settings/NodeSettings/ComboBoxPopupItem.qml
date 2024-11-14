import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

DapRectangleLitAndShaded
{
    id: mainItem

    property string networkFullName: ""
    property string networkRole: ""

    property bool node: true
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    signal confirm()

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

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

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
//        anchors.leftMargin: 34
//        anchors.rightMargin: 34
        spacing: 0

        PageHeaderItem
        {
            headerName: networkFullName + qsTr(" node role")
        }

        HeaderItem
        {
            headerName: qsTr("Select ") + networkFullName + qsTr(" node role")
        }

        DapCustomComboBox
        {
            id: comboBoxNodeRole
            Layout.fillWidth: true
            Layout.minimumHeight: 40
            Layout.maximumHeight: 40
            Layout.topMargin: 16
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            model: nodeRole
            rightMarginIndicator: 4

            font: mainFont.dapFont.regular16

//                defaultText: qsTr("Full")
        }

        Text
        {
            Layout.fillWidth: true
            Layout.topMargin: 16
            Layout.leftMargin: 16
            Layout.rightMargin: 16

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

        Item
        {
            Layout.fillHeight: true
        }

        DapButton
        {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.bottomMargin: 40
            implicitHeight: 36
            implicitWidth: 162

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

                root.dapRightPanel.pop()

                mainItem.confirm()
            }
        }

    }

}

