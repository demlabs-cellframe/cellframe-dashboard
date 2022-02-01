import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: window
    visible: true
    width: 320
    height: 480

    property alias mainStackView: stackView

    title: qsTr("Stack")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        RowLayout
        {
            anchors.fill: parent

            ToolButton {
                id: toolButton
//                text: stackView.depth > 1 ? "\u25C0" : "\u2630"
//                icon.source: "qrc:/mobile/Icons/MenuIcon.png"
                icon.source: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                onClicked: {
                    if (stackView.depth > 1) {
//                        stackView.pop()
                        stackView.clearAll()
                    } else {
                        mainDrawer.open()
                    }
                }
            }

            Label {
                text: stackView.currentItem.title
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
//                anchors.centerIn: parent
            }

            ToolButton {
                id: toolButton1
                icon.source: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                enabled: stackView.depth <= 1
                onClicked: {
                    networkDrawer.open()
                }
            }

        }

    }

    MainMenu
    {
        id: mainDrawer
        width: parent.width * 0.66
        height: parent.height
    }

    NetworkMenu
    {
        id: networkDrawer
        width: parent.width * 0.66
        height: parent.height
    }

    MainStackView {
        id: stackView
        anchors.fill: parent
        initialItem: "qrc:/mobile/Wallet/MainWallet.qml"
    }
}
