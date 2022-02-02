import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "qrc:/resources/QML"

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
            Layout.preferredHeight: 44 * pt

            RowLayout
            {
                anchors.fill: parent
                anchors.leftMargin: 10 * pt

                Image {
                    Layout.alignment: Qt.AlignVCenter
                    sourceSize.width: 24 * pt
                    sourceSize.height: 24 * pt
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/mobile/Icons/MenuIconLight.png"
                }
                Text {
//<<<<<<< HEAD
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.leftMargin: 5 * pt
//=======
//                    Layout.alignment: Qt.AlignVCenter
//                    Layout.leftMargin: 10 * pt
//                    Layout.fillWidth: true
//>>>>>>> a5ba176aa92549cb6e6f0622eaf68269744d0b08
                    text: qsTr("Cellframe Dashboard")
                    color: currTheme.textColor
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                }
                Item {
                    Layout.fillWidth: true
                }
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
                height: 40 * pt
                anchors.left: parent.left
                anchors.right: parent.right

                ItemDelegate {

                    text: qsTr(modelData.name)
                    id: ico

                    contentItem:
                        RowLayout
                        {
                            anchors.fill: parent
                            anchors.leftMargin: 15 * pt
                            spacing: 0
                            Image {
//                                    anchors.left: parent.left
                                sourceSize.width: 16 * pt
                                sourceSize.height: 16 * pt
                                fillMode: Image.PreserveAspectFit
                                source: "qrc:/resources/icons/" + pathTheme + "/LeftIcons/" + modelData.bttnIco
                            }
                            Text {

                                Layout.leftMargin: 10 * pt
                                text: qsTr(modelData.name)
                                color: currTheme.textColor
                                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
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
            "url": walletsModel.count > 0 ? "qrc:/mobile/Wallet/TokenWallet.qml" : "qrc:/mobile/Wallet/MainWallet.qml"
        },
        {
            "name": qsTr("Exchange"),
            "bttnIco": "icon_exchange.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("TX Explorer"),
            "bttnIco": "icon_history.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("Certificates"),
            "bttnIco": "icon_certificates.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("Tokens"),
            "bttnIco": "icon_tokens.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("VPN client"),
            "bttnIco": "vpn-client_icon.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("VPN service"),
            "bttnIco": "icon_vpn.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("Logs"),
            "bttnIco": "icon_logs.png",
            "url": "qrc:/mobile/PageComingSoon.qml"
        },
        {
            "name": qsTr("Settings"),
            "bttnIco": "icon_settings.png",
            "url": "qrc:/mobile/Settings/MainSettings.qml"
        }
    ]

//        ItemDelegate {
//            text: qsTr("Cellframe Dashboard")
//            icon.source: "qrc:/mobile/Icons/MenuIconLight.png"
//            width: parent.width
//        }

//        ItemDelegate {
//            text: qsTr("Wallet")
//            icon.source: "qrc:/mobile/Icons/IconWallet.png"
//            width: parent.width
//            onClicked: {
//                mainStackView.setInitialItem("qrc:/mobile/Wallet/MainWallet.qml")
//                drawer.close()
//            }
//        }

//        ItemDelegate {
//            text: qsTr("Exchange")
//            icon.source: "qrc:/mobile/Icons/IconExchange.png"
//            width: parent.width
//            onClicked: {
//                mainStackView.setInitialItem("qrc:/mobile/Page1Form.ui.qml")
//                drawer.close()
//            }
//        }

//        ItemDelegate {
//            text: qsTr("History")
//            icon.source: "qrc:/mobile/Icons/IconHistory.png"
//            width: parent.width
//            onClicked: {
//                mainStackView.setInitialItem("qrc:/mobile/PageComingSoon.qml")
//                drawer.close()
//            }
//        }

//        ItemDelegate {
//            text: qsTr("Certificates")
//            icon.source: "qrc:/mobile/Icons/IconCertificates.png"
//            width: parent.width
//            onClicked: {
//                mainStackView.setInitialItem("qrc:/mobile/Page2Form.ui.qml")
//                drawer.close()
//            }
//        }
//    }
}
