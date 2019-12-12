import QtQuick 2.0
import QtQuick.Controls 2.0
import "./StatusBar"
import "./LastAction"

Page {
    id: dapUiQmlScreenMainWindow
    title: qsTr("General")

    /// ----------- Load fonts -----------
    /// using example: font.family: fontRobotoLight.name
    readonly property FontLoader fontRobotoLight: FontLoader {
        source: "qrc:/res/fonts/roboto_light.ttf"
    }
    readonly property FontLoader fontRobotoRegular: FontLoader {
        source: "qrc:/res/fonts/roboto_regular.ttf"
    }

    readonly property FontLoader fontRobotoMedium: FontLoader {
        source: "qrc:/res/fonts/roboto_medium.ttf"
    }
    /// -----------
    property alias listViewTabs: listViewTabs
    property alias stackViewScreenDashboard: stackViewScreenDashboard
    property alias rightPanel: rightPanel

    DapUiQmlWidgetStatusBar {
        id: rectangleStatusBar
        anchors.left: rectangleTabsBorder.right
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#070023"
        height: 60 * pt
    }

    Rectangle {
        id: rectangleTabsBorder
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#070023"
        width: 160 * pt

        ListView {
            id: listViewTabs
            anchors.fill: parent
            anchors.topMargin: 60 * pt
            model: listModelTabs
            spacing: 3

            ListModel {
                id: listModelTabs

                ListElement {
                    name: qsTr("Dashboard")
                    page: "qrc:/screen/Dashboard/DapUiQmlScreenDashboard.qml"
                    normal: "qrc:/res/icons/icon_dashboard.png"
                    hover: "qrc:/res/icons/icon_dashboard_hover.png"
                    panelHeader: "qrc:/screen/LastAction/DapUiQmlWidgetLastActionsHeaderForm.qml"
                    panelContent: "qrc:/screen/LastAction/DapUiQmlWidgetHistoryLastActions.qml"
                }

                ListElement {
                    name: qsTr("Exchange")
                    page: "qrc:/screen/Exchange/DapUiQmlScreenExchangeForm.ui.qml"
                    normal: "qrc:/res/icons/icon_exchange.png"
                    hover: "qrc:/res/icons/icon_exchange_hover.png"
                    panelHeader: ""
                    panelContent: ""
                }

                ListElement {
                    name: qsTr("History")
                    page: "qrc:/screen/History/DapUiQmlScreenHistory.qml"
                    normal: "qrc:/res/icons/icon_history.png"
                    hover: "qrc:/res/icons/icon_history_hover.png"
                    panelHeader: ""
                    panelContent: ""
                }

                ListElement {
                    name: qsTr("Console")
                    page: "qrc:/screen/Console/DapUiQmlScreenConsoleForm.ui.qml"
                    normal: "qrc:/res/icons/icon_console.png"
                    hover: "qrc:/res/icons/icon_console_hover.png"
                    panelHeader: "qrc:/screen/LastAction/DapUiQmlWidgetLastActionsHeaderForm.qml"
                    panelContent: "qrc:/screen/Console/DapUiQmlWidgetConsoleLastActionsForm.qml"
                }

                ListElement {
                    name: qsTr("Logs")
                    page: "qrc:/screen/Log/DapUiQmlWidgetChainNodeLogs.qml"
                    normal: "qrc:/res/icons/icon_logs.png"
                    hover: "qrc:/res/icons/icon_logs_hover.png"
                    panelHeader: ""
                    panelContent: ""
                }

                ListElement {
                    name: qsTr("Settings")
                    page: "qrc:/screen/Settings/DapUiQmlScreenSettings.qml"
                    normal: "qrc:/res/icons/icon_settings.png"
                    hover: "qrc:/res/icons/icon_settings_hover.png"
                    panelHeader: ""
                    panelContent: ""
                }

                ListElement {
                    name: qsTr("VPN")
                    page: "qrc:/screen/VPN/DapUiQmlScreenVpn.qml"
                    normal: "qrc:/res/icons/defaul_icon.png"
                    hover: "qrc:/res/icons/defaul_icon.png"
                    panelHeader: ""
                    panelContent: ""
                }

                /// TODO: It wasn't in the task. I will not delete it, maybe later
                /// we will need it
                //                    ListElement {
                //                        name:  qsTr("About")
                //                        page: "DapQmlScreenAbout.qml"
                //                        source: "qrc:/Resources/Icons/defaul_icon.png"
                //                    }
            }
            delegate: componentItemMainMenuTab
            clip: true
            interactive: false
            currentIndex: 0
        }
        focus: true
    }

    property alias rightPanelLoaderSource: rightPanelLoader.source

    Rectangle {
        id: mainDashboard
        anchors.left: rectangleTabsBorder.right
        anchors.top: rectangleStatusBar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        Loader {
            id: stackViewScreenDashboard
            clip: true
            anchors.left: parent.left
            anchors.right: rightPanel.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            source: "qrc:/screen/Dashboard/DapUiQmlScreenDashboard.qml"
        }
    }

    DapUiQmlWidgetRightPanel {
        id: rightPanel
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: parent.right
        header.initialItem: "DapUiQmlWidgetLastActionsHeaderForm.qml"
        content.initialItem: "DapUiQmlWidgetHistoryLastActions.qml"
        width: 400 * pt

        Loader {
            id: rightPanelLoader
            clip: true
            anchors.fill: parent
            source: "DapUiQmlWidgetLastActions.qml"
        }

        Connections {
            target: rectangleStatusBar
            onAddWalletPressedChanged: rightPanelLoader.source
                                       = "DapUiQmlScreenDialogAddWalletForm.ui.qml"
        }

        Connections {
            target: rightPanelLoader.item
            onPressedCloseAddWalletChanged: rightPanelLoader.source
                                            = "DapUiQmlWidgetLastActions.qml"
            onPressedDoneCreateWalletChanged: rightPanelLoader.source
                                              = "DapUiQmlWidgetLastActions.qml"
            onPressedNextButtonChanged: {
                if (rightPanelLoader.item.isWordsRecoveryMethodChecked)
                    rightPanelLoader.source = "DapUiQmlRecoveryNotesForm.ui.qml"
                else if (rightPanelLoader.item.isQRCodeRecoveryMethodChecked)
                    rightPanelLoader.source = "DapUiQmlRecoveryQrForm.ui.qml"
                else if (rightPanelLoader.item.isExportToFileRecoveryMethodChecked)
                    console.debug(
                                "Export to file") /*TODO: create dialog select file to export */
                else
                    rightPanelLoader.source = "DapUiQmlWalletCreatedForm.ui.qml"
            }
            onPressedBackButtonChanged: rightPanelLoader.source
                                        = "DapUiQmlScreenDialogAddWalletForm.ui.qml"
            onPressedNextButtonForCreateWalletChanged: rightPanelLoader.source
                                                       = "DapUiQmlWalletCreatedForm.ui.qml"
        }

        Connections {
            target: stackViewScreenDashboard.item
            onPressedNewPaymentButtonChanged: rightPanelLoader.source = "DapUiQmlNewPayment.qml"
        }

        Connections {
            target: rightPanelLoader.item
            onPressedSendButtonChanged: rightPanelLoader.source
                                        = "DapUiQmlStatusNewPaymentForm.ui.qml"
            onPressedCloseButtonChanged: rightPanelLoader.source = "DapUiQmlWidgetLastActions.qml"
            onPressedDoneNewPaymentButtonChanged: rightPanelLoader.source
                                                  = "DapUiQmlWidgetLastActions.qml"
        }
    }
}
