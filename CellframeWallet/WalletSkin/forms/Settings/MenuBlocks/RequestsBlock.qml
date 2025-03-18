import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"
import "../"

ColumnLayout {
    anchors.fill: parent
//    anchors.margins: 16
    spacing: 0

    HeaderSection{
        Layout.fillWidth: true
        height: 30
        text: qsTr("Requests to work with the wallet")
    }

    ListView {
        id: requestsView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16

        model: dapMessageBuffer
        interactive: true
        clip: true
        spacing: 0
        delegate: delegate

        Behavior on Layout.preferredHeight {
            NumberAnimation{duration: 200}
        }
    }

    Component{
        id: delegate

        ColumnLayout{
            id: delegateItem
            width: requestsView.width

            Text{
                id: infoText
                Layout.topMargin: 16
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                font: mainFont.dapFont.regular14
                color: currTheme.white
                text: qsTr("The site ") + site + qsTr(" requests permission to exchange work with the wallet")

            }

            Text{
                Layout.topMargin: 8
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.fillHeight: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                color: currTheme.gray
                font: mainFont.dapFont.regular13
                text: date

            }

            RowLayout{
                id: buttonsLayout
                Layout.fillWidth: true
                Layout.topMargin: 12

                spacing: 13

                DapButton{
                    id: leftBut
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: 17
                    implicitWidth: 152
                    implicitHeight: 26

                    listInteractivFlagDisabled: true
                    parentList: requestsView

                    textButton: qsTr("Allow")
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked:{
                       app.webConnectRespond(true, indexRequest)
                       delegateItem.eventMessage("Allowed")
                    }
                }

                DapButton{
                    id: righttBut
                    Layout.rightMargin: 16
                    implicitWidth: 152
                    implicitHeight: 26

                    listInteractivFlagDisabled: true
                    parentList: requestsView

                    textButton: qsTr("Deny")
                    fontButton: mainFont.dapFont.medium14
                    horizontalAligmentText: Text.AlignHCenter
                    onClicked: {
                        app.webConnectRespond(false, indexRequest)
                        delegateItem.eventMessage("Denied")
                    }
                }
            }
            Rectangle{
                Layout.fillWidth: true
                Layout.topMargin: 16
                height: 1
                color: currTheme.secondaryBackground
            }

            function eventMessage(reply)
            {
                logicMainApp.requestsMessageCounter--
                for(var i = 0; i < dapMessageBuffer.count; i++)
                {
                    if(dapMessageBuffer.get(i).site === site)
                    {
                        dapMessageBuffer.remove(i)
                        break;
                    }
                }
            }
        }
    }
}
