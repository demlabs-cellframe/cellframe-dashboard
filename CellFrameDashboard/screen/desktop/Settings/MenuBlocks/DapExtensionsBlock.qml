import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Page
{
    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 19

        DapRectangleLitAndShaded
        {
            visible: app.getNodeMode() === 0
            id:extensionsBlock
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            Layout.minimumHeight:  105
            Layout.maximumHeight: (parent.height - parent.spacing) / 2
            Layout.preferredHeight: contentData.implicitHeight

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData:
                ColumnLayout
            {
                anchors.fill: parent

                spacing: 0

                Item
                {
                    Layout.fillWidth: true
                    height: 42

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        font: mainFont.dapFont.bold14
                        color: currTheme.white
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr("dApps")
                    }
                }
                Rectangle
                {
                    Layout.fillWidth: true
                    height: 30
                    color: currTheme.mainBackground

                    Text
                    {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        font: mainFont.dapFont.medium12
                        color: currTheme.white
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
                            Layout.preferredHeight: 50
                            Layout.fillWidth: true

                            RowLayout
                            {
                                anchors.fill: parent
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 0

                                DapBigText
                                {
                                    id: nameText
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                    Layout.maximumWidth: 250
                                    width: nameText.textElement.implicitWidth
                                    height: 40
                                    textFont: mainFont.dapFont.regular14
                                    fullText: name
                                }

                                DapSwitch
                                {
                                    id: switchApp
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                    Layout.preferredHeight: 26
                                    Layout.preferredWidth: 46
                                    indicatorSize: 30

                                    backgroundColor: currTheme.mainBackground
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

                                        dapSettingsScreen.switchAppsTab(modelAppsTabStates.get(index).tag, name, checked)
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
                                height: 1
                                color: currTheme.mainBackground

                            }
                        }
                    }
                }
            }

//            onVisibleChanged:
//            {
//                if(visible)
//                    separatop.visible = false
//                else
//                    separatop.visible = true
//            }
        }

        DapRectangleLitAndShaded
        {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.minimumHeight:  105
            Layout.maximumHeight: !app.getNodeMode() ? (parent.height - parent.spacing) / 2
                                                     : parent.height

            Layout.preferredHeight: contentData.implicitHeight

            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
            shadowColor: currTheme.shadowColor
            lightColor: currTheme.reflectionLight

            contentData: DapLinksBlock{}
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
