import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "../resources/theme"
import "qrc:/widgets/"
import "qrc:/resources/QML"

ApplicationWindow {
    id: window
    visible: true
    width: 320
    height: 480

    property alias dapQuicksandFonts: quicksandFonts
    DapFontQuicksand {
        id: quicksandFonts
    }
    Dark { id: darkTheme }
    Light { id: lightTheme }

    property string pathTheme: "BlackTheme"

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme


    property alias mainStackView: stackView

    title: qsTr("Cellframe Dashboard")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    header: ToolBar {
        contentHeight: 56 * pt

        background:
            Item {
                anchors.fill: parent
                Rectangle {
                    id: headerRect
                    Rectangle {
                        width: parent.width
                        height: 30
                        anchors.top: parent.top
                        color: "#282A33"
                    }
                    anchors.fill: parent
                    color: "#282A33"
                    radius: 20
                }
                InnerShadow {
                    anchors.fill: headerRect
                    radius: 3.0
                    samples: 16
                    horizontalOffset: 0
                    verticalOffset: -1
                    color: "#858585"
                    source: headerRect
                }
        }



        RowLayout
        {
            anchors.fill: parent
            anchors.leftMargin: 10 * pt
            anchors.rightMargin: -4 * pt

            DapButton
            {
                Layout.preferredHeight: 40 * pt
                Layout.preferredWidth: 40 * pt
                id: toolButton
                normalImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
                hoverImageButton: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
                height: 40 * pt
                width: 40 * pt
                widthImageButton: 24 * pt
                heightImageButton: 24 * pt
                indentImageLeftButton: 0 * pt
                transColor: true

                onClicked: {
                    if (stackView.depth > 1) {
//                        stackView.pop()
                        stackView.clearAll()
                    } else {
                        mainDrawer.open()
                    }
                }
            }

//            ToolButton {
//                id: toolButton
////                text: stackView.depth > 1 ? "\u25C0" : "\u2630"
////                icon.source: "qrc:/mobile/Icons/MenuIcon.png"
//                icon.source: stackView.depth > 1 ? "qrc:/mobile/Icons/Close.png" : "qrc:/mobile/Icons/MenuIcon.png"
//                font.pixelSize: Qt.application.font.pixelSize * 1.6

//                onClicked: {
//                    if (stackView.depth > 1) {
////                        stackView.pop()
//                        stackView.clearAll()
//                    } else {
//                        drawer.open()
//                    }
//                }
//            }

            Label {
                Layout.fillWidth: true
                text: stackView.currentItem.title
                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.textColor
//                anchors.centerIn: parent
            }

            DapButton
            {
                Layout.preferredHeight: 40 * pt
                Layout.preferredWidth: 40 * pt
                id: toolButton1
                normalImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
                hoverImageButton: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
                height: 40 * pt
                width: 40 * pt
                widthImageButton: 24 * pt
                heightImageButton: 24 * pt
                indentImageLeftButton: 0 * pt
                transColor: true
                enabled: stackView.depth <= 1
                onClicked: {
                    networkDrawer.open()
                }
            }

//            ToolButton {
//                id: toolButton1
//                icon.source: stackView.depth > 1 ?  "" : "qrc:/mobile/Icons/NetIcon.png"
//                font.pixelSize: Qt.application.font.pixelSize * 1.6
//                enabled: stackView.depth <= 1
//            }

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
