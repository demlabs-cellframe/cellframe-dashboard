import QtQuick 2.5
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import "qrc:/widgets"

Popup {
    id: popup

    property bool isOpen: false
    property int indexUser
    property string webSite

    property real tempH: parent.height

    width: parent.width
//    height: checkButton.visible? 178+72 : 196+72
    height: 340

    modal: false
    closePolicy: Popup.NoAutoClose
    padding: 0

    parent: Overlay.overlay
    x: 0
//    y: parent.height - height
    y: dapMainWindow.height + systemFrameContent.header.height

    visible: isOpen

//    background: Rectangle
//    {
//        border.width: 0
//        radius: 30
//        color: currTheme.backgroundElements
//    }

    Behavior on y{
        NumberAnimation{
            duration: 200
        }
    }

    //blocked area
    MouseArea{
        parent: dapMainWindow
        anchors.fill: parent
        enabled: isOpen
        visible: isOpen
        hoverEnabled: isOpen
        onWheel: {}
        onClicked: clearAndClose()
    }


    background: Rectangle {
        color: currTheme.mainBackground
        radius: 30
        border.width: 1
        border.color: currTheme.border
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            color: currTheme.mainBackground
        }
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.bottomMargin: 1
            color: currTheme.mainBackground
        }
    }

    contentItem:
    ColumnLayout{
        spacing: 0

        DapImageRender {
            Layout.margins: 16
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    clearAndClose()
                }
            }
        }


        Text{
            Layout.topMargin: 28
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Request permission to work\nwith your wallet")
            font: mainFont.dapFont.medium18
            color: currTheme.white
        }

        Text{
            id: infoText
            Layout.topMargin: 16
            Layout.leftMargin: 31
            Layout.rightMargin: 31
            Layout.bottomMargin: 100
            Layout.fillHeight: true
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font: mainFont.dapFont.regular14
            color: currTheme.white
        }

    }

    DapButton{
        id: checkButton
        visible: false
        Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        Layout.bottomMargin: 45

//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 45
//        anchors.horizontalCenter: parent.horizontalCenter
//        Layout.alignment: Qt.AlignHCenter
//        Layout.bottomMargin: 24
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
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 45
//        anchors.horizontalCenter: parent.horizontalCenter
        Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
////            Layout.topMargin: 36
        Layout.bottomMargin: 45

        spacing: 16

        DapButton{
            id: rightBut
            implicitWidth: 132
            implicitHeight: 36

            textButton: qsTr("Deny")
            fontButton: mainFont.dapFont.regular14
            horizontalAligmentText: Text.AlignHCenter
            onClicked: {
                app.webConnectRespond(false, indexUser)
                eventMessage("Denied")
            }
        }

        DapButton{
            id: leftBut
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: 132
            implicitHeight: 36

            textButton: qsTr("Allow")
            fontButton: mainFont.dapFont.regular14
            horizontalAligmentText: Text.AlignHCenter
            onClicked: {
                app.webConnectRespond(true, indexUser)
                eventMessage("Allowed")
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
            infoText.text = qsTr("The site ") + text + qsTr(" requests permission to exchange work with the wallet")
        }
        else
        {
            buttonsLayout.visible = false
            checkButton.visible = true
            infoText.text = qsTr("You have ") + text + qsTr(" requests permission to exchange work with the wallet")
        }
    }

    function clearAndClose()
    {
        y = tempH
        isOpen = false
        webSite = ""
        indexUser = -1
        infoText.text = ""

        popup.close()
    }

    function openPopup()
    {
        isOpen = true
        open()
        popup.y = dapMainWindow.height - popup.height  + systemFrameContent.header.height
    }
}
