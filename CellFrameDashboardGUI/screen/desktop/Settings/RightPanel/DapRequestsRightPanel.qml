import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import "../../controls"
import "qrc:/widgets"

Page {
    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

                onClicked: navigator.popPage()
            }

            Text
            {
                id: textHeader
                text: qsTr("Requests")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.medium14
                color: currTheme.textColor
            }
        }

        Rectangle
        {
            color: currTheme.backgroundMainScreen
            Layout.fillWidth: true
            height: 30 * pt
            Text
            {
                color: currTheme.textColor
                text: qsTr("Requests to work with a wallet")
                font: mainFont.dapFont.medium12
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16 * pt
                anchors.topMargin: 20 * pt
                anchors.bottomMargin: 5 * pt
            }
        }

        ListView{
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: dapMessageBuffer
            ScrollBar.vertical: ScrollBar {
                active: true
            }
            delegate:
                ColumnLayout{
                    id: delegateItem
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 125

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
                        color: currTheme.textColor
                        text: "The site " + site + " requests permission to exchange work with the wallet"

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
                            fontButton: mainFont.dapFont.regular14
                            horizontalAligmentText: Text.AlignHCenter
                            onClicked:{
                                dapServiceController.notifyService("DapWebConnectRequest",true, indexRequest)
                               delegateItem.eventMessage("Allowed")
                            }
                        }

                        DapButton{
                            id: righttBut
                            Layout.rightMargin: 16
                            implicitWidth: 152
                            implicitHeight: 26

                            textButton: qsTr("Deny")
                            fontButton: mainFont.dapFont.regular14
                            horizontalAligmentText: Text.AlignHCenter
                            onClicked: {
                                dapServiceController.notifyService("DapWebConnectRequest",false, indexRequest)
                                delegateItem.eventMessage("Denied")
                            }
                        }
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
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.topMargin: 16
                        height: 1
                        color: currTheme.lineSeparatorColor
                    }
                }
        }
    }
}
