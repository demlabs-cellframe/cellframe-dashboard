import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../controls" as Controls
import "qrc:/widgets" as Widgets

Controls.DapTopPanel
{

    property alias buttonUpdate: checkUpdate
    property alias indicatorUpdate: loadIndicator

    RowLayout
    {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24


        //Requests
        Item {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            width: row.implicitWidth
            height: 20

            RowLayout{
                id: row
                spacing: 6
                anchors.fill: parent

                Text{
                    Layout.fillHeight: true
                    Layout.topMargin: 1
                    Layout.bottomMargin: 1
                    id: requestsBut
                    text: qsTr("Requests")
                    font: mainFont.dapFont.medium14
                    color: mouseArea.containsMouse ? currTheme.orange : logicMainApp.requestsMessageCounter > 0 ? currTheme.lime : currTheme.white
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                }

                Rectangle{
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                    width: value.implicitWidth > 8 ? value.implicitWidth + 12  : 20
                    radius: 20
                    visible: logicMainApp.requestsMessageCounter > 0
                    color: mouseArea.containsMouse ? currTheme.orange : currTheme.lime

                    Text{
                        id: value
                        anchors.fill: parent
                        text: logicMainApp.requestsMessageCounter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: currTheme.boxes
                        font: mainFont.dapFont.regular13
                    }
                }
            }

            MouseArea{
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: navigator.openRequests()
            }

            Connections
            {
                target: dapMainWindow
                function onOpenRequests(){ navigator.openRequests()}
            }
        }

        Item{Layout.fillWidth: true}

        // Wallet controller
        ColumnLayout{
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 6

            spacing: 2

            RowLayout{
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr( "Wallet controller" )
                    font: mainFont.dapFont.regular13
                    color: currTheme.white
                    elide: Text.ElideMiddle
                }
            }

            RowLayout{
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: qsTr( "Edit wallets list" )
                    font: mainFont.dapFont.regular13
                    enabled: walletModelList.count > 0 ? true : false
                    color: enabled ? walletsArea.containsMouse ? currTheme.orange : currTheme.lime : currTheme.gray


                    MouseArea{
                        id: walletsArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: navigator.openWalletsController()
                    }
                }
            }
        }

        // Node settings
        ColumnLayout{
            Layout.alignment: Qt.AlignRight
            Layout.leftMargin: 45
            spacing: 2
            visible: app.getNodeMode() === 0

            RowLayout{
                spacing: 8

                Text {
                    id: notifyStateText

                    Layout.alignment: Qt.AlignLeft

                    text: qsTr( "Node connection status:" )
                    font: mainFont.dapFont.regular13
                    color: currTheme.white
                    elide: Text.ElideMiddle
                }

                Widgets.DapImageLoader {
                    id: notifyState
                    Layout.preferredHeight: 8
                    Layout.preferredWidth: 8

                    innerWidth: 8
                    innerHeight: 8

                    source:
                    {
                        if(app.getNodeMode() === 0)
                        {
                            return dapNotifyController.isConnected ? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png":
                                                                     "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.png"
                        }
                        return "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.png"
                    }
                }
            }

            RowLayout{
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignLeft

                    text: qsTr( "Node settings" )
                    font: mainFont.dapFont.regular13
                    color: settingsArea.containsMouse ? currTheme.orange
                                                      : currTheme.lime
                    elide: Text.ElideMiddle

                    MouseArea{
                        id: settingsArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: navigator.openNodeSettings()
                    }
                }
                Text {
                    Layout.alignment: Qt.AlignLeft

                    text: "|"
                    font: mainFont.dapFont.regular13
                    color: currTheme.gray
                    elide: Text.ElideMiddle
                }
                Text {
                    Layout.alignment: Qt.AlignLeft

                    text: qsTr( "Clear node data" )
                    font: mainFont.dapFont.regular13
                    color: clearArea.containsMouse ? currTheme.orange
                                                      : currTheme.lime
                    elide: Text.ElideMiddle

                    MouseArea{
                        id: clearArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: clearMessagePopup.smartOpen(
                                       qsTr("Clear node data"),
                                       qsTr("Confirming will clear all chain and GDB data. It will take time to reload data and synchronize"))
                    }
                }
            }
        }

        // Version
        ColumnLayout
        {
            Layout.leftMargin: 53
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 32
            spacing: 2

            Text {
                id: vesion
                Layout.alignment: Qt.AlignLeft
                horizontalAlignment: Text.AlignLeft

                text: qsTr( "Dashboard version " + settingsModule.dashboardVersion)
                font: mainFont.dapFont.regular13
                color: currTheme.gray

            }
            RowLayout
            {
                Layout.alignment: Qt.AlignLeft
//                visible: app.getNodeMode() === 0
                Text {
                    horizontalAlignment: Text.AlignLeft

                    text: qsTr( "Node version ")
                    font: mainFont.dapFont.regular13
                    color: currTheme.gray
                }
                Text {
                    id: vesionNode
                    text: settingsModule.nodeVersion
                    font: mainFont.dapFont.regular13
                    color: app.getNodeMode() === 1 ? currTheme.gray
                                                   : vesionNodeArea.containsMouse ? currTheme.orange
                                                                                  : currTheme.lime

                    MouseArea{
                        id: vesionNodeArea
                        anchors.fill: parent
                        hoverEnabled: app.getNodeMode() === 0
                        onClicked:
                        {
                            dapMainWindow.showPopupUpdateNode()
                        }
                    }
                }
            }


        }

        Widgets.DapButton
        {
            id: checkUpdate
            textButton: qsTr("Check update")
            Layout.alignment: Qt.AlignRight

            implicitHeight: 36
            implicitWidth: 164
            fontButton: mainFont.dapFont.medium14
            horizontalAligmentText: Text.AlignHCenter

            Controls.DapLoadIndicator {
                id: loadIndicator

                anchors.verticalCenter: parent.verticalCenter

                anchors.right: checkUpdate.right
                anchors.rightMargin: 5
                indicatorSize: 16

                countElements: 5
                elementSize: 4

                running: settingsModule.guiRequest
            }
            onClicked:
            {
                settingsModule.guiVersionRequest()
            }

            Widgets.DapCustomToolTip{
                contentText: qsTr("Check update")
            }
        }

    }
}
