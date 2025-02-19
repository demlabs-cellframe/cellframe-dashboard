import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQml 2.12
import "qrc:/widgets"

Rectangle{

    property bool resizeFlag: false
    property real resizeRectangleSize: 5
    property real moveRectangleSize: 5
    property alias header: header
    property alias dataItem: dataItem.data

    color: "transparent"
    border.width: OS_WIN_FLAG && !fullScreen.FULLSCREEN ? 1 : 0
    border.color: currTheme.mainBackground

    Rectangle{
        id: header
        visible: header.enabled
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: resizeFlag ? resizeRectangleTop.bottom : parent.top
        height: OS_WIN_FLAG && !fullScreen.FULLSCREEN ? 30 : 0
        color: currTheme.mainBackground

        MouseArea {
            enabled: parent.enabled
            anchors.fill: parent
            onPressed: {
                window.startSystemMove()
            }
        }

        RowLayout{
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 1
            spacing: 0

            DapImageRender{
                source: "qrc:/walletSkin/Resources/BlackTheme/icons/WalletLogo.svg"
            }

            Text{
                Layout.leftMargin: 5
                text: qsTr("Cellframe Wallet")
                font.family: "Nunito"
                font.pixelSize: 14
                color: currTheme.white
            }

            Item{
                Layout.fillWidth: true
            }

            Rectangle{
                Layout.topMargin: -5
                Layout.preferredHeight: 24
                Layout.preferredWidth: 50
                color: areaHide.containsMouse ? currTheme.secondaryBackground : currTheme.mainBackground

                DapImageRender{
                    anchors.centerIn: parent
                    source: "qrc:/walletSkin/Resources/BlackTheme/icons/icon_hideWindow.svg"
                }

                MouseArea{
                    id: areaHide
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.showMinimized()
                }
            }

            Rectangle{
                Layout.topMargin: -5
                Layout.preferredHeight: 24
                Layout.preferredWidth: 50

                color: areaClose.containsMouse ? "#e81123" : currTheme.mainBackground

                DapImageRender{
                    anchors.centerIn: parent
                    source: "qrc:/walletSkin/Resources/BlackTheme/icons/icon_closeWindow.svg"
                }
                MouseArea{
                    id: areaClose
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Qt.quit()
                }
            }
        }
    }

    MouseArea {
        id: resizeRectangleRight
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        enabled: resizeFlag
        width: resizeRectangleSize
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
        onPressed: {
            window.startSystemResize(Qt.RightEdge);
        }
    }


    MouseArea {
        id: resizeRectangleLeft
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: resizeRectangleSize
        enabled: resizeFlag
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeHorCursor : Qt.ArrowCursor
        onPressed: {
            window.startSystemResize(Qt.LeftEdge);
        }
    }

    MouseArea {
        id: resizeRectangleTop
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        height: resizeRectangleSize
        enabled: resizeFlag
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
        onPressed: {
            window.startSystemResize(Qt.TopEdge);
        }
    }


    MouseArea {
        id: resizeRectangleBottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: resizeRectangleSize
        enabled: resizeFlag
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.SizeVerCursor : Qt.ArrowCursor
        onPressed: {
            window.startSystemResize(Qt.BottomEdge);
        }
    }

    Item{
        id: dataItem
//        x: 0
//        y: header.height
        anchors.fill: parent
        anchors.margins: OS_WIN_FLAG && !fullScreen.FULLSCREEN ? 1 : 0
        anchors.topMargin: OS_WIN_FLAG && !fullScreen.FULLSCREEN ? header.height : 0
    }
}

