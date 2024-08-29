import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Page {
    property bool isOpen: false
    property int indexUser
    property string webSite
    property real startY: parent.height
    property real stopY: parent.height - popup.height - networksPanel.height - 24

    id: popup

    width: 328
    height: checkButton.visible? 178 : 196

    anchors.right: parent.right
    anchors.rightMargin: 24

    y: startY

    Timer{
        property int counter: 0
        id: timer
        interval: 200
        repeat: true
        onTriggered: {
            if(counter === 20){
                running = false
                counter = 0
            }else{
                counter++
                popup.y = stopY
            }
        }
    }

    Connections{
        target: dapMainWindow
        function onChangeHeight() {
            startY = parent.height
            if(isOpen)
                timer.start()
            else
                y = startY
        }
    }

    visible: isOpen
    z: 10

    background: Item {
        Rectangle {
            id: rPopup
            width: parent.width
            height: parent.height
            visible: true
            color: currTheme.secondaryBackground
            radius: currTheme.frameRadius
        }

        DropShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.reflection
            horizontalOffset: -1
            verticalOffset: -1
            radius: 0
            samples: 0
            opacity: 1
            fast: true
            cached: true
        }
        DropShadow {
            anchors.fill: rPopup
            source: rPopup
            color: currTheme.shadowColor
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: 1
        }
    }

    Behavior on y {
        NumberAnimation {
            duration: 200
        }
    }

    contentItem: ColumnLayout{

        spacing: 0

        HeaderButtonForRightPanels{
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.topMargin: 14.5
            Layout.rightMargin: 14.5
            height: 10 
            width: 10 
            heightImage: 20 
            widthImage: 20 
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

            onClicked:
            {
                clearAndClose()
            }
        }

        Text{
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Request to work with a wallet")
            font: mainFont.dapFont.medium14
            color: currTheme.white
        }

        Text{
            id: infoText
            Layout.topMargin: 16
            Layout.leftMargin: 31
            Layout.rightMargin: 31
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular14
            color: currTheme.white
        }

        DapButton{
            id: checkButton
            visible: false
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 24
            implicitWidth: 132
            implicitHeight: 36
            textButton: qsTr("Check")
            fontButton: mainFont.dapFont.regular14
            horizontalAligmentText: Text.AlignHCenter

            onClicked:{
                checkWebRequest()
                clearAndClose()
            }
        }

        RowLayout{
            id: buttonsLayout
            Layout.fillWidth: true
            Layout.bottomMargin: 24


            spacing: 16

            DapButton{
                id: leftBut
                Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: 24
                implicitWidth: 132
                implicitHeight: 36

                textButton: qsTr("Allow")
                fontButton: mainFont.dapFont.regular14
                horizontalAligmentText: Text.AlignHCenter
                onClicked:{
                    console.log("Connection window the Allow button is clicked");
                    dapServiceController.webConnectRespond(true, indexUser)
                    eventMessage("Allowed")
                }
            }

            DapButton{
                id: righttBut
                Layout.rightMargin: 24
                implicitWidth: 132
                implicitHeight: 36

                textButton: qsTr("Deny")
                fontButton: mainFont.dapFont.regular14
                horizontalAligmentText: Text.AlignHCenter
                onClicked: {
                    console.log("Connection window the Allow button is clicked");
                    dapServiceController.webConnectRespond(false, indexUser)
                    eventMessage("Denied")
                }
            }
        }
    }

    function eventMessage(reply)
    {
        logicMainApp.requestsMessageCounter--
        for(var i = 0; i < dapMessageBuffer.count; i++)
        {
            if(dapMessageBuffer.get(i).site === webSite)
            {
                dapMessageBuffer.remove(i)
                dapMessageLogBuffer.append({infoText: "The site " + webSite + " requests permission to work with your wallet",
                                            date: logicMainApp.getDate("yyyy-MM-dd, hh:mm ap"),
                                            reply: reply})
                break;
            }
        }
        clearAndClose()
    }

    function setDisplayText(isSingle, text, index)
    {
        if(isSingle)
        {
            buttonsLayout.visible = true
            checkButton.visible = false
            webSite = text
            indexUser = index
            infoText.text = qsTr("The site ") + text + qsTr(" requests permission to work with your wallet")
        }
        else
        {
            buttonsLayout.visible = false
            checkButton.visible = true
            infoText.text = qsTr("You have ") + text + qsTr(" requests permission to work with your wallet")

            if(isOpen)
                y = stopY
        }
    }

    function clearAndClose()
    {
        y = startY
        logicMainApp.delay(200, function(){
            isOpen = false
            webSite = ""
            indexUser = -1
            infoText.text = ""
        })
    }

    function open()
    {
        console.log("[Open] Open the connection window with the client via Web3");
        isOpen = true
        y = stopY
    }
}
