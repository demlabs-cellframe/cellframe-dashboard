import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item{
    property alias headerText: textHeader.text
    property alias messageText: textMessage.text
    property alias doneButton: buttonDone
    property alias messageImage: imageMessage.source
    property alias pageHeight: page.height


    property string iconOk:"qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/Verified.svg"
    property string iconBad:"qrc:/walletSkin/Resources/" + pathTheme + "/icons/other/no_icon.png"


    Page {
        id: page
        y: dapMainWindow.height + height
        width: parent.width
        hoverEnabled: true

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        Component.onCompleted:
            y = dapMainWindow.height - height
        Component.onDestruction:
            y = dapMainWindow.height + height


        height: 471
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
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                color: currTheme.mainBackground
            }
        }

        DapImageRender {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: dapBottomPopup.hide()
            }
        }

        Item
        {
            anchors.fill: parent
            anchors.leftMargin: 34
            anchors.rightMargin: 34

            DapImageLoader
            {
                id: imageMessage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50
                innerWidth: 88
                innerHeight: 88
            }

            Text
            {
                id: textHeader
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 150
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.white
                font: mainFont.dapFont.medium27
            }

            Text
            {
                id: textMessage
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 226
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: currTheme.white
                font: mainFont.dapFont.medium18
            }

            DapButton
            {
                id: buttonDone
                anchors.top: parent.top
                anchors.topMargin: 317
                anchors.horizontalCenter: parent.horizontalCenter
                implicitHeight: 36
                implicitWidth: 132
                textButton: qsTr("Done")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.regular14
            }
        }
    }
}
