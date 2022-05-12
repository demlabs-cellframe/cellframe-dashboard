import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout
{
    id:control
    anchors.fill: parent

    spacing: 0

    Item
    {
        Layout.fillWidth: true
        height: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 14 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Extensions")
        }
    }
    Rectangle
    {
        Layout.fillWidth: true
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
            font: mainFont.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Manage dApps")
        }
    }

    ListModel
    {
        id: modelApps
        Component.onCompleted:
        {
            for(var i = 0; i < dapModelPlugins.count; i++)
            {
                if(dapModelPlugins.get(i).status === "1")
                    modelApps.append({name:dapModelPlugins.get(i).name, status:dapModelPlugins.get(i).status})

            }
        }
    }

    ListView
    {
        id:listWallet
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model:modelApps
        clip: true
        delegate: delegateList

    }

    Component{
        id:delegateList

        ColumnLayout
        {
            id:columnWallets
            anchors.left: parent.left
            anchors.right: parent.right
            onHeightChanged: listWallet.contentHeight = height
            spacing: 0

            Item {
                Layout.preferredHeight: 50 * pt
                Layout.fillWidth: true

                RowLayout
                {
                    anchors.fill: parent
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0
//                    anchors.topMargin: 16 * pt
//                    anchors.bottomMargin: 16 * pt

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.leftMargin: 15 * pt
                        Layout.maximumWidth: 250

                        font: mainFont.dapFont.regular14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: name
                        elide: Text.ElideMiddle
                    }

                    DapSwitch
                    {
                        id: switchApp
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 26 * pt
                        Layout.preferredWidth: 46 * pt
                        Layout.rightMargin: 15 * pt

                        backgroundColor: currTheme.backgroundMainScreen
                        borderColor: currTheme.reflectionLight
                        shadowColor: currTheme.shadowColor

                        checked:{
                           var i = getIndex(name)
                           return i >= 0 ? modelAppsTabStates.get(i).show : false
                        }
                        onToggled: {
                            var i = getIndex(name)
                            if(i >= 0)
                                modelAppsTabStates.get(i).show = checked

                            settingScreen.switchAppsTab(modelAppsTabStates.get(index).tag, name, checked)
                        }

                        function getIndex(nameExt)
                        {
                            for(var i = 0; i < modelAppsTabStates.count; i++ )
                            {
                                if(modelAppsTabStates.get(i).name === nameExt)
                                    return i
                            }
                            return -1
                        }
                    }
                }
                Rectangle
                {
//                    visible: index === listWallet.count - 1? false : true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor

                }
            }
        }
    }
}
