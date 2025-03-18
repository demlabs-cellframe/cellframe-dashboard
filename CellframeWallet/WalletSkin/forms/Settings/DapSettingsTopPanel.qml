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
        Item{
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
    //                    anchors.leftMargin: 6
    //                    anchors.rightMargin: 6
    //                    anchors.topMargin: 2
    //                    anchors.bottomMargin: 2
                        text: logicMainApp.requestsMessageCounter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: currTheme.mainBackground
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
                onOpenRequests: navigator.openRequests()
            }
        }

        Item{Layout.fillWidth: true}


        RowLayout{
            Layout.alignment: Qt.AlignRight
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

                source: dapServiceController.notifyState ? "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/indicator_online.png":
                                                  "qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/indicator_error.png"
            }
        }

        ColumnLayout
        {
            Layout.leftMargin: 56
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 40
            spacing: 2

            Text {
                id: vesion
                Layout.alignment: Qt.AlignLeft
                horizontalAlignment: Text.AlignLeft

                text: qsTr( "Wallet version ") + dapServiceController.Version
                font: mainFont.dapFont.regular13
                color: currTheme.gray

            }
            Text {
                id: vesionNode
                Layout.alignment: Qt.AlignLeft
                horizontalAlignment: Text.AlignLeft

                text: qsTr( "Node version ") + cellframeNodeWrapper.nodeVersion
                font: mainFont.dapFont.regular13
                color: currTheme.gray

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

                running: sendRequest
            }
            onClicked:
            {
                sendRequest = true
            }
        }

    }
}
