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
            font: _dapQuicksandFonts.dapFont.bold14
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
            font: _dapQuicksandFonts.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Manage dApps")
        }
    }


    ListModel
    {
        id: modelApps
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
//                    anchors.topMargin: 16 * pt
//                    anchors.bottomMargin: 16 * pt

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.leftMargin: 15 * pt

                        font: _dapQuicksandFonts.dapFont.regular14
                        color: currTheme.textColor
                        verticalAlignment: Qt.AlignVCenter
                        text: name
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

                        checked: modelAppsTabStates.get(index).show
                        onToggled: {
                            modelAppsTabStates.get(index).show = checked
                            switchAppsTab(modelAppsTabStates.get(index).tag, modelAppsTabStates.get(index).name, checked)
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

    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            if(index === currentIndex)
            {
                modelApps.clear()
                for(var i = 0; i < _dapModelPlugins.count; i++)
                {
                    if(_dapModelPlugins.get(i).status === "1")
                        modelApps.append({name:_dapModelPlugins.get(i).name, status:_dapModelPlugins.get(i).status})

                }
            }
        }
    }
}
