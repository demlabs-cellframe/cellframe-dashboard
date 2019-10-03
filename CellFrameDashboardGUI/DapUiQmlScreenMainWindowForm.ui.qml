import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import CellFrameDashboard 1.0

Page {
    id: dapUiQmlScreenMainWindow
    title: qsTr("General")

    /// ----------- Load fonts -----------
    /// using example: font.family: fontRobotoLight.name
    readonly property FontLoader fontRobotoLight: FontLoader { source: "qrc:/Resources/Fonts/roboto_light.ttf" }
    readonly property FontLoader fontRobotoRegular: FontLoader { source: "qrc:/Resources/Fonts/roboto_regular.ttf" }
    /// -----------

    property alias listViewTabs: listViewTabs
    property alias stackViewScreenDashboard: stackViewScreenDashboard


    Rectangle
    {
        id: rectangleStatusBar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#070023"
        height: 60 * pt
    }

    Rectangle
    {
        id: rectangleTabsBorder
        anchors.top: rectangleStatusBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#070023"
        width: 160 * pt

        ListView {
            id: listViewTabs
            anchors.fill: parent
            model: listModelTabs
            spacing: 3

            ListModel {
                id: listModelTabs

                ListElement {
                    name:  qsTr("Dashboard")
                    page: "DapUiQmlScreenDialog.qml"
                    normal: "qrc:/Resources/Icons/icon_dashboard.png"
                    hover: "qrc:/Resources/Icons/icon_dashboard_hover.png"
                }

                ListElement {
                    name:  qsTr("Exchange")
                    page: "DapUiQmlScreenExchangeForm.ui.qml"
                    normal: "qrc:/Resources/Icons/icon_exchange.png"
                    hover: "qrc:/Resources/Icons/icon_exchange_hover.png"
                }

                ListElement {
                    name:  qsTr("History")
                    page: "DapUiQmlScreenHistory.qml"
                    normal: "qrc:/Resources/Icons/icon_history.png"
                    hover: "qrc:/Resources/Icons/icon_history_hover.png"
                }

                ListElement {
                    name:  qsTr("Console")
                    page: "DapUiQmlScreenConsoleForm.ui.qml"
                    normal: "qrc:/Resources/Icons/icon_console.png"
                    hover: "qrc:/Resources/Icons/icon_console_hover.png"
                }

                ListElement {
                    name:  qsTr("Logs")
                    page: "DapUiQmlWidgetChainNodeLogs.qml"
                    normal: "qrc:/Resources/Icons/icon_logs.png"
                    hover: "qrc:/Resources/Icons/icon_logs_hover.png"
                }

                ListElement {
                    name:  qsTr("Settings")
                    page: "DapQmlScreenAbout.qml"
                    normal: "qrc:/Resources/Icons/defaul_icon.png"
                    hover: "qrc:/Resources/Icons/defaul_icon.png"
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

        }
        focus: true
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
