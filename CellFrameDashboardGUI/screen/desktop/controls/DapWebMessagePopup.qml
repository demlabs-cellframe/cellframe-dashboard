import QtQuick 2.4
import QtQml 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Popup {
    property bool isOpen: false
    property int indexUser
    property string webSite
    property real startY: parent.height
    property real stopY: -height*(1 + 1/scale)*0.5 + parent.height - networksPanel.height - 24

    onOpenedChanged: isOpen = !isOpen

    id: popup

    width: 328
    height: checkButton.visible? 178 : 196
//    height: 178

    x: parent.width - popup.width/scale - 24

    scale: mainWindow.scale

    closePolicy: Popup.NoAutoClose
    padding: 0

    background: Item {
        Rectangle {
            id: rPopup
            width: parent.width
            height: parent.height
            visible: true
            color: currTheme.backgroundElements
            radius: currTheme.radiusRectangle
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


    enter: Transition {
//                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
                NumberAnimation { property: "y"; from: startY; to: stopY; duration: 200 }
            }
    exit: Transition {
//                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
                NumberAnimation { property: "y"; from: stopY; to: startY; duration: 200 }
            }

    contentItem: ColumnLayout{

        spacing: 0

        HeaderButtonForRightPanels{
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            Layout.topMargin: 14.5
            Layout.rightMargin: 14.5
            height: 10 * pt
            width: 10 * pt
            heightImage: 20 * pt
            widthImage: 20 * pt
            normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
            hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"

            onClicked:
            {

                popup.close()
            }
        }

        Text{
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Request to work with a wallet")
            font: mainFont.dapFont.medium14
            color: currTheme.textColor
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
            color: currTheme.textColor
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
                popup.close()
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
                onClicked:
                {
                    dapServiceController.notifyService("DapWebConnectRequest",true, indexUser)
                    logicMainApp.requestsMessageCounter--

                    popup.close()
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
                    dapServiceController.notifyService("DapWebConnectRequest",false, indexUser)
                    logicMainApp.requestsMessageCounter--
                    popup.close()
                }
            }
        }
    }
    function setDisplayText(isSingle, text, index)
    {

        console.log("Y = ", y, "________________________________________________________-")

        if(isSingle)
        {
            buttonsLayout.visible = true
            checkButton.visible = false
            webSite = text
            indexUser = index
            infoText.text = "The site " + text + " requests permission to exchange work with the wallet"
        }
        else
        {
            buttonsLayout.visible = false
            checkButton.visible = true
            infoText.text = "You have " + text + " requests permission to exchange work with the wallet"

            if(isOpen)
                y += 18
        }
    }
}
