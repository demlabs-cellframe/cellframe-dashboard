import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "../../controls"
import "qrc:/widgets"

DapRectangleLitAndShaded {

    Component.onCompleted: {logicMainApp.isOpenRequests = true; webPopup.clearAndClose()}
    Component.onDestruction: logicMainApp.isOpenRequests = false

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

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

                onClicked:
                    navigator.popPage()
            }

            Text
            {
                id: textHeader
                text: qsTr("Requests")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        Rectangle
        {
            color: currTheme.mainBackground
            Layout.fillWidth: true
            height: 30 
            Text
            {
                color: currTheme.white
                text: qsTr("Requests to work with a wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
            }
        }

        MouseArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            acceptedButtons: Qt.NoButton
            onWheel: {
              wheel.accepted = true
                if (wheel.angleDelta.y !== 0) {
                 view.flick(0, wheel.angleDelta.y * 5)
                }
            }

            ListView{
                id: view

                anchors.fill: parent
                clip: true
                interactive: false
                model: dapMessageBuffer
                ScrollBar.vertical: ScrollBar {
                    active: true
                }
                delegate:
                    ColumnLayout{
                        id: delegateItem
                        width: view.width
//                        height: preferredHeight
//                        height: 133
                        z: 10

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
                            text: qsTr("The site ") + site +
                                  qsTr(" requests permission to work with your wallet")

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

                                textButton: qsTr("Allow")
                                fontButton: mainFont.dapFont.medium14
                                horizontalAligmentText: Text.AlignHCenter
                                onClicked:{
                                   dapServiceController.webConnectRespond(true, indexRequest)
                                   delegateItem.eventMessage("Allowed")
                                }
                            }

                            DapButton{
                                id: righttBut
                                Layout.rightMargin: 16
                                implicitWidth: 152
                                implicitHeight: 26

                                textButton: qsTr("Deny")
                                fontButton: mainFont.dapFont.medium14
                                horizontalAligmentText: Text.AlignHCenter
                                onClicked: {
                                    dapServiceController.webConnectRespond(false, indexRequest)
                                    delegateItem.eventMessage("Denied")
                                }
                            }
                        }
                        Rectangle{
                            Layout.fillWidth: true
                            Layout.topMargin: 16
                            height: 1
                            color: currTheme.mainBackground
                        }

                        function eventMessage(reply)
                        {
                            logicMainApp.requestsMessageCounter--
                            for(var i = 0; i < dapMessageBuffer.count; i++)
                            {
                                if(dapMessageBuffer.get(i).site === site)
                                {
                                    dapMessageBuffer.remove(i)
                                    dapMessageLogBuffer.append({infoText: infoText.text,
                                                                date: logicMainApp.getDate("yyyy-MM-dd, hh:mm ap"),
                                                                reply: reply})
                                    break;
                                }
                            }
                        }
                    }
            }
        }
    }
}
