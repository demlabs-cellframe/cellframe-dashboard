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
            bottomMargin: 21
            leftMargin: 24
            topMargin: 21
        }
        width: row.implicitWidth

        RowLayout{
            id: row
            spacing: 6
            anchors.fill: parent

            Text{
                Layout.fillHeight: true
                id: requestsBut
                text: qsTr("Requests")
                font: mainFont.dapFont.medium14
                color: logicMainApp.requestsMessageCounter > 0 ? currTheme.hilightColorComboBox : currTheme.textColor
                Layout.alignment: Qt.AlignVCenter
            }

            Rectangle{
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 20
                radius: 20
                visible: logicMainApp.requestsMessageCounter > 0
                color: currTheme.hilightColorComboBox

                Text{
                    id: value
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: logicMainApp.requestsMessageCounter
                    color: currTheme.hilightTextColorComboBox
                    font: mainFont.dapFont.regular13
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        MouseArea{
            anchors.fill: parent
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
            rightMargin: 24 * pt
            topMargin: 23 * pt
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
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: 38 * pt
        implicitWidth: 163 * pt
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
            rightMargin: 24 * pt
            topMargin: 23 * pt
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
            Layout.preferredHeight: 8 * pt
            Layout.preferredWidth: 8 * pt
            innerWidth: 8 * pt
            innerHeight: 8 * pt

            source: logicMainApp.stateNotify? "qrc:/Resources/" + pathTheme + "/icons/other/indicator_online.png":
                                              "qrc:/Resources/" + pathTheme + "/icons/other/indicator_error.png"

        }
    }
}
