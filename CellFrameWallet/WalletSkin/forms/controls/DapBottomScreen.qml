import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import qmlclipboard 1.0
import "qrc:/widgets"

Item{
    property alias clipboard: clipboard
    property alias closeButton: closeButton
    property alias backButton: backButton
    property alias header: header
    property Item dataItem
//    property int heightForm
    property alias heightForm: root.height
    property alias form: root

    property real shift: 0
    signal animationStopped()

    signal closedClicked()

    onHeightChanged:
    {
        anim.enabled = false
        root.y = height + shift
        anim.enabled = true
    }

    Page {
        id: root
        hoverEnabled: true

        signal updateY()

        onUpdateY:
        {
            anim.enabled = false
            shift = - height
            y = parent.height + shift
            anim.enabled = true
        }

//        y: 0
        y: parent.height + shift
        width: parent.width
//        height: heightForm

        Behavior on y{
            id: anim
            NumberAnimation{
                duration: 200
            }
        }

        onYChanged:
        {
            if(parent.height - height === y)
            {
                animationStopped()
            }
        }

        QMLClipboard{
            id: clipboard
        }

        Component.onCompleted:
        {
            shift = - height
            y = parent.height + shift
        }
        Component.onDestruction:
        {
            shift = 0
            y = parent.height + shift
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

        DapImageRender {
            id: closeButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    closedClicked()
                    dapBottomPopup.hide()
                }
            }
        }

        DapImageRender {
            id: backButton
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 16
            visible: false

            source: areaBack.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/back_hover.svg" :
                                            "qrc:/walletSkin/Resources/BlackTheme/icons/new/back.svg"

            MouseArea{
                id: areaBack
                anchors.fill: parent
                hoverEnabled: true
                onClicked: dapBottomPopup.pop()
            }
        }

        Text{
            id: header
            anchors.left: backButton.right
            anchors.right: closeButton.left
            anchors.top: parent.top
//            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 16
            height: 18
            font: mainFont.dapFont.bold14
            color: currTheme.white

            horizontalAlignment: Text.AlignHCenter
        }

        Item{
            anchors.fill: parent
            anchors.topMargin: 34

            data: dataItem
        }
    }
}
