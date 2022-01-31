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

    header: RowLayout {
        Rectangle {
            anchors.fill: parent
            color: currTheme.backgroundPanel
            radius: 10
        }

        Item {
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            Image {
                anchors.fill: parent
                source: "qrc:/resources/icons/burger_menu_icon.png"
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: titleText
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.textColor
                text: qsTr("Wallet")
            }
            Text {
                id: walletName
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: currTheme.textColor
                text: qsTr("Name of my wallet")
            }
        }

        Item {
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            Image {
                anchors.fill: parent
                source: "qrc:/resources/icons/network_icon.png"
            }
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
}
