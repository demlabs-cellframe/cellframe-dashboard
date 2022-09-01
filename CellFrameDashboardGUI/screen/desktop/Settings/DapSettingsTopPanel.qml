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

    //Requests
    Item{
        anchors
        {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            bottomMargin: 20
            leftMargin: 24
            topMargin: 20
        }
        width: row.implicitWidth

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
                color: mouseArea.containsMouse ? currTheme.textColorYellow : logicMainApp.requestsMessageCounter > 0 ? currTheme.hilightColorComboBox : currTheme.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

            }

            Rectangle{
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                width: value.implicitWidth > 8 ? value.implicitWidth + 12  : 20
                radius: 20
                visible: logicMainApp.requestsMessageCounter > 0
                color: mouseArea.containsMouse ? currTheme.textColorYellow : currTheme.hilightColorComboBox

                Text{
                    id: value
                    anchors.fill: parent
                    anchors.leftMargin: 6
                    anchors.rightMargin: 6
                    anchors.topMargin: 2
                    anchors.bottomMargin: 2
                    text: logicMainApp.requestsMessageCounter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: currTheme.hilightTextColorComboBox
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

    Text {
        id: vesion
        anchors
        {
            right: checkUpdate.left
            top: parent.top
            rightMargin: 24 
            topMargin: 23 
        }

        text: qsTr( "Version " + dapServiceController.Version)
        font: mainFont.dapFont.regular12
        color: currTheme.textColor

    }

    Widgets.DapButton
    {
        id: checkUpdate
        textButton: "Check update"

        anchors.right: parent.right
        anchors.rightMargin: 24 
        anchors.top: parent.top
        anchors.topMargin: 14 
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: 38 
        implicitWidth: 163 
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
            dapServiceController.requestToService("DapVersionController", "version")
        }
    }

    RowLayout {
        anchors
        {
            right: vesion.left
            top: parent.top
            rightMargin: 24 
            topMargin: 23 
        }

        Text {
            id: notifyStateText

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true

            text: qsTr( "Node connection status " )
            font: mainFont.dapFont.regular12
            color: currTheme.textColor
            elide: Text.ElideMiddle
        }

        Widgets.DapImageLoader {
            id: notifyState
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 8 
            Layout.preferredWidth: 8 
            innerWidth: 8 
            innerHeight: 8 

            source: logicMainApp.stateNotify? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png":
                                              "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.png"

        }
    }
}
