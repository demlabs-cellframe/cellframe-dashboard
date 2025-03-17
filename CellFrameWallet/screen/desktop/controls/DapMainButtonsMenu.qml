import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Drawer {
    id: control

    width: parent.width * 0.7
    height: parent.height
    edge: Qt.LeftEdge

    //property alias mainButtonsList: mainButtonsList

    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 30
        Rectangle {
            width: 30
            height: 30
            anchors.top: parent.top
            anchors.left: parent.left
            color: currTheme.backgroundElements
        }
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: currTheme.backgroundElements
        }
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: currTheme.backgroundElements
        }
    }

    ColumnLayout {
        id: mainButtonsColumn
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            ItemDelegate {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 25
                Layout.margins: 10

                Image {
                    anchors.fill: parent
                    source: "qrc:/resources/icons/burger_menu_icon.png"
                }
            }
            Text {
                id: headerText
                Layout.fillWidth: true
                Layout.margins: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                text: qsTr("Cellframe Wallet")
                color: currTheme.textColor
            }
        }

        Rectangle {
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.rightMargin: 25
            color: "#4f4f4f"
        }

        ListView {
            id: mainButtonsList
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 5
            clip: true
            model: mainButtonsModel

            delegate: DapMenuButtonMobile { }
        }
    }

    property var mainButtonsModel: [
        {
            "name": qsTr("Wallet"),
            "bttnIco": "icon_wallet.png"
        },
        {
            "name": qsTr("Exchange"),
            "bttnIco": "icon_exchange.png"
        },
        {
            "name": qsTr("TX Explorer"),
            "bttnIco": "icon_history.png"
        },
        {
            "name": qsTr("Certificates"),
            "bttnIco": "icon_certificates.png"
        },
        {
            "name": qsTr("Tokens"),
            "bttnIco": "icon_tokens.png"
        },
        {
            "name": qsTr("VPN client"),
            "bttnIco": "vpn-client_icon.png"
        },
        {
            "name": qsTr("VPN service"),
            "bttnIco": "icon_vpn.png"
        },
        {
            "name": qsTr("Console"),
            "bttnIco": "icon_console.png"
        },
        {
            "name": qsTr("Settings"),
            "bttnIco": "icon_settings.png"
        },
        {
            "name": qsTr("Test"),
            "bttnIco": "icon_settings.png"
        }
    ]

}
