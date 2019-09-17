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


    Rectangle
    {
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
                        name:  qsTr("Dashboard")
                        page: "DapUiQmlScreenDialog.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name:  qsTr("Exchange")
                        page: "DapUiQmlScreenExchangeForm.ui.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name:  qsTr("Settings")
                        page: "DapQmlScreenAbout.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name:  qsTr("Logs")
                        page: "DapUiQmlWidgetChainNodeLogs.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name:  qsTr("History")
                        page: "DapUiQmlScreenHistory.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                    ListElement {
                        name:  qsTr("About")
                        page: "DapQmlScreenAbout.qml"
                        source: "qrc:/Resources/Icons/defaul_icon.png"
                    }
                }
                delegate: componentItemMainMenuTab

            }
            focus: true
        }
    }

    Rectangle
    {
        id: rectangleStatusBar
        anchors.left: rectangleTabsBorder.right
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#B5B5B5"
        height: 60
        Rectangle
        {
            anchors.fill: parent
            anchors.bottomMargin: 1
            color: "#F2F2F4"
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
