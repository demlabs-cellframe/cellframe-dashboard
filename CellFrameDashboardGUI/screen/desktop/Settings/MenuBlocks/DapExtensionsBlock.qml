import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout
{
    id:control
    anchors.fill: parent
    Item
    {
        Layout.fillWidth: true
        Layout.preferredHeight: 38 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 15 * pt
            anchors.topMargin: 15 * pt
            anchors.bottomMargin:  5 * pt
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Extensions")
        }
    }
    Rectangle
    {
        Layout.fillWidth: true
        Layout.preferredHeight: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.left: parent.left
            anchors.leftMargin: 17 * pt
            anchors.verticalCenter: parent.verticalCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium11
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

            Item {
                Layout.preferredHeight: 50 * pt
                Layout.fillWidth: true

                RowLayout
                {
                    anchors.fill: parent
                    anchors.topMargin: 5 * pt
                    anchors.bottomMargin: 15 * pt

                    Text
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.leftMargin: 15 * pt

                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
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