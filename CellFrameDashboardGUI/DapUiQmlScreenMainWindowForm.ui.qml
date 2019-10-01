import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import CellFrameDashboard 1.0

Page {
    id: dapUiQmlScreenMainWindow
    title: qsTr("General")

    property alias listViewTabs: listViewTabs
    property alias stackViewScreenDashboard: stackViewScreenDashboard

    Rectangle {
        id: rectangleTabsBorder
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#B5B5B5"
        width: 150
        Rectangle {
            id: rectangleTabs
            anchors.fill: parent
            anchors.leftMargin: 1
            anchors.rightMargin: 1

            color: "#E1E4E6"
            ListView {
                id: listViewTabs
                anchors.fill: parent
                model: listModelTabs
                spacing: 3

                ListModel {
                    id: listModelTabs

                    ListElement {
                        name: qsTr("Dashboard")
                        page: "DapUiQmlScreenDialog.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("Exchange")
                        page: "DapUiQmlScreenExchangeForm.ui.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("Settings")
                        page: "DapQmlScreenAbout.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("Logs")
                        page: "DapUiQmlWidgetChainNodeLogs.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("History")
                        page: "DapUiQmlScreenHistory.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("Console")
                        page: "DapUiQmlScreenConsoleForm.ui.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name: qsTr("About")
                        page: "DapQmlScreenAbout.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                }
                delegate: componentItemMainMenuTab
            }
            focus: true
        }
    }

    Rectangle {
        id: rectangleStatusBar
        anchors.left: rectangleTabsBorder.right
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#B5B5B5"
        height: 60 * pt
        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: 1
            color: "#F2F2F4"

            ComboBox {
                id: comboboxWallet
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 30 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                model: dapChainWalletsModel
                textRole: "name"

                indicator: Image {
                    source: comboboxWallet.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
                    width: 24 * pt
                    height: 24 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * pt
                }
            }

            Label {
                id: titleWalletBalance
                anchors.top: parent.top
                anchors.left: comboboxWallet.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 40 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                verticalAlignment: Qt.AlignVCenter
                text: "Wallet balance:"
                font.family: "Regular"
                font.pixelSize: 12 * pt
                color: "#A7A7A7"
            }

            Label {
                id: fieldWalletBalance
                anchors.top: parent.top
                anchors.left: titleWalletBalance.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 16 * pt
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 10 * pt
                verticalAlignment: Qt.AlignVCenter
                font.family: "Regular"
                font.pixelSize: 16 * pt
                color: "#797979"
                text: "$ 0"
            }

            Button {
                width: 130 * pt
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 10 * pt
                anchors.rightMargin: 20 * pt
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10 * pt

                contentItem: Rectangle {
                    anchors.fill: parent
                    border.color: "#B5B5B5"
                    border.width: 1 * pt
                    color: "transparent"

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignRight
                        anchors.rightMargin: 20 * pt
                        font.family: "Regular"
                        color: "#505559"
                        text: qsTr("New wallet")
                    }

                    Image {
                        id: iconNewWallet
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10 * pt
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                        width: 28 * pt
                        height: 28 * pt
                    }
                }
            }
        }
    }

    Rectangle {
        id: mainDashboard
        anchors.left: rectangleTabsBorder.right
        anchors.top: rectangleStatusBar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        border.color: "whitesmoke"

        Loader {
            id: stackViewScreenDashboard
            clip: true
            anchors.fill: parent
            source: "DapUiQmlScreenDialog.qml"
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

