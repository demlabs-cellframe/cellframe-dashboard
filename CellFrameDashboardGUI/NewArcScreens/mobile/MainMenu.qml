import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "qrc:/resources/QML"
import "qrc:/widgets"

Drawer {
    id: drawer

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
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 47 * pt

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10 * pt

                Image {
                    smooth: true
                    Layout.maximumWidth: 30 * pt
                    Layout.maximumHeight: 30 * pt
                    fillMode: Image.PreserveAspectFit
                    source: "Icons/MenuIconLightGreen.png"
                }
//                DapImageLoader {
//                    Layout.alignment: Qt.AlignVCenter
//                    innerWidth: 30 * pt
//                    innerHeight: 30 * pt
////                    fillMode: Image.PreserveAspectFit
//                    source: "qrc:/mobile/Icons/MenuIconLightGreen.png"
//                }
                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.leftMargin: 5 * pt
                    Layout.fillWidth: true
                    text: qsTr("Cellframe Dashboard")
                    color: currTheme.textColor
                    font: mainFont.dapFont.medium18
                }
                Item {
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    drawer.close()
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
            clip: true
            model: mainButtonsModel

            delegate:
                Item {
                height: 52 * pt
                anchors.left: parent.left
                anchors.right: parent.right

                ItemDelegate {
                    anchors.fill: parent

                    text: qsTr(modelData.name)
                    id: ico


                    contentItem:
                        RowLayout
                        {
//                            anchors.verticalCenter: parent
                            spacing: 0
                            Image {
                                smooth: true
                                Layout.leftMargin: 5 * pt
                                Layout.maximumWidth: 16 * pt
                                Layout.maximumHeight: 16 * pt
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/" + modelData.bttnIco
                            }
//                            DapImageLoader {
//                                Layout.leftMargin: 5 * pt
//                                innerWidth: 16 * pt
//                                innerHeight: 16 * pt
//                                source: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/" + modelData.bttnIco
//                            }
                            Text {
                                Layout.fillWidth: true
                                Layout.leftMargin: 10 * pt
                                horizontalAlignment: Qt.AlignLeft

                                text: qsTr(modelData.name)
                                color: currTheme.textColor
                                font: mainFont.dapFont.medium16
                            }
                        }

                }
                MouseArea
                {
                    anchors.fill: parent

                    onClicked:
                    {
                        mainStackView.setInitialItem(modelData.url)
                        drawer.close()
                    }
                }
            }
        }
    }

    property var mainButtonsModel: [
        {
            "name": qsTr("Wallet"),
            "bttnIco": "icon_wallet.png",
            "url": walletPage
        },
        {
            "name": qsTr("Exchange"),
            "bttnIco": "icon_exchange.png",
            "url": exchangePage
        },
        {
            "name": qsTr("TX Explorer"),
            "bttnIco": "icon_history.png",
            "url": txExplorerPage
        },
        {
            "name": qsTr("Certificates"),
            "bttnIco": "icon_certificates.png",
            "url": certificatesPage
        },
        {
            "name": qsTr("Tokens"),
            "bttnIco": "icon_tokens.png",
            "url": tokensPage
        },
        {
            "name": qsTr("VPN client"),
            "bttnIco": "vpn-client_icon.png",
            "url": vpnClientPage
        },
        {
            "name": qsTr("VPN service"),
            "bttnIco": "icon_vpn.png",
            "url": vpnServicePage
        },
        {
            "name": qsTr("Logs"),
            "bttnIco": "icon_logs.png",
            "url": logsPage
        },
        {
            "name": qsTr("dApps"),
            "bttnIco": "icon_logs.png",
            "url": dAppsPage
        },
        {
            "name": qsTr("Settings"),
            "bttnIco": "icon_settings.png",
            "url": settingsPage
        }
    ]
}
