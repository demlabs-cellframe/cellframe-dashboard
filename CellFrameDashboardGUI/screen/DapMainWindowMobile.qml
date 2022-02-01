import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import "../screen"
import "qrc:/resources/QML"
import "../screen/controls"
import "../resources/theme"

Page {
    id: root

    readonly property string walletPage: "qrc:/screen/mobile/Wallet/WalletPage.qml"

    Dark { id: darkTheme }
    Light { id: lightTheme }

    property string pathTheme: "BlackTheme"

    property bool currThemeVal: true
    property var currTheme: currThemeVal ? darkTheme : lightTheme

    //property string title: qsTr("Main window")

    header: GridLayout {
        //height: 100
        rows: 2
        columns: 3

        Rectangle {
            id: headerRect
            Rectangle {
                width: parent.width
                height: 30
                anchors.top: parent.top
                color: currTheme.backgroundPanel
            }
            anchors.fill: parent
            color: currTheme.backgroundPanel
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

        ItemDelegate {
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            Layout.leftMargin: 10

            Image {
                anchors.fill: parent
                source: "qrc:/resources/icons/burger_menu_icon.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainButtonsMenu.open()
                }
            }
        }

        Text {
            id: titleText
            Layout.fillWidth: true
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.textColor
            text: qsTr("Wallet")
        }

        ItemDelegate {
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            Layout.rightMargin: 10

            Image {
                anchors.fill: parent
                source: "qrc:/resources/icons/network_icon.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {

                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        Text {
            id: walletName
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            color: currTheme.textColor
            text: qsTr("Name of my wallet")
        }

        Item {
            Layout.fillHeight: true
        }
    }

    background: Rectangle {
        color: currTheme.backgroundElements
    }

    StackView {
        id: mainStackView
        anchors.fill: parent

        initialItem: walletPage
    }

    DapMainButtonsMenu {
        id: mainButtonsMenu
    }
}
