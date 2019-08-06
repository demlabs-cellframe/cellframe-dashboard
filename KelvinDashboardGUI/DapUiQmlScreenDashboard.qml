import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Page {
    id: dapUiQmlScreenDashboard
    title: qsTr("General")

    Rectangle {
        id: rectangleTabs
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 150
        color: "#36314D"
        ListView {
            id: listViewTabs
            anchors.fill: parent
            model: listModelTabs
            spacing: 3

            ListModel {
                id: listModelTabs

                ListElement {
                    name:  qsTr("Home")
                    page: "DapUiQmlScreenDialog.qml"
                    source: "qrc:/Resources/Icons/home.png"
                }
                ListElement {
                    name:  qsTr("Settings")
                    page: "DapQmlScreenAbout.qml"
                    source: "qrc:/Resources/Icons/settings.png"
                }
                ListElement {
                    name:  qsTr("Logs")
                    page: "DapUiQmlWidgetChainNodeLogs.qml"
                    source: "qrc:/Resources/Icons/logs.png"
                }
                ListElement {
                    name:  qsTr("About")
                    page: "DapQmlScreenAbout.qml"
                    source: "qrc:/Resources/Icons/about.png"
                }
            }



            delegate:
                Component {
                    id: componentTab
                    Rectangle {
                        id: componentItem
                        width: listViewTabs.width
                        height: 150
                        color: listViewTabs.currentIndex === index ? "#48435F" : "#3E3856"
                        Column
                        {
                            spacing: 20
                            anchors.centerIn: parent
                            Image
                            {
                                id: imageMenu
                                source: model.source
                                height: 64
                                width: 64
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text
                            {
                                text: qsTr(name)
                                color: "#CFCBD9"
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.family: "Roboto"
                                font.pointSize: 12
                            }
                        }

                        MouseArea {
                               anchors.fill: parent
                               onClicked:
                               {
                                   listViewTabs.currentIndex = index
                                   stackViewScreenDashboard.setSource(Qt.resolvedUrl(page))
                               }
                           }
                        }
                    }
                }
            focus: true
    }
        Rectangle
        {
            id: rectangleExit
            color: "transparent"
            width: listViewTabs.width
            height: 150
            anchors.left: parent.left
            anchors.bottom: parent.bottom

                Column
                {
                    spacing: 20
                    anchors.centerIn: parent
                    Image
                    {
                        id: imageMenu
                        source: "qrc:/Resources/Icons/exit.png"
                        height: 64
                        width: 64
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text
                    {
                        text: qsTr("Exit")
                        color: "#CFCBD9"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "Roboto"
                        font.pointSize: 12
                    }
                }

                MouseArea {
                       anchors.fill: parent
                       onHoveredChanged:
                       {
                           rectangleExit.color = "#48435F"
                       }

                       onClicked:
                       {

                           Qt.quit()
                       }
                   }
        }
        Rectangle {
            id: mainDashboard
            anchors.left: rectangleTabs.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            border.color: "whitesmoke"

            Loader {
                id: stackViewScreenDashboard
                anchors.fill: parent
                source: "DapUiQmlScreenDialog.qml"
            }
        }
}

