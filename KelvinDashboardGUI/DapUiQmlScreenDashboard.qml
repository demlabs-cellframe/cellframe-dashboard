import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

Page {
    id: dapUiQmlScreenDashboard
    title: qsTr("General")

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
                        name:  qsTr("Home")
                        page: "DapUiQmlScreenDialog.qml"
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



                delegate:
                    Column {
                    id: componentTab
                    height: 148
                    Rectangle {
                        id: componentItem
                        property bool isPushed: listViewTabs.currentIndex === index

                        width: listViewTabs.width
                        height: 150
                        color: "transparent"
                        Rectangle
                        {
                            id: spacerItem1
                            height: 25
                            anchors.top: parent.top
                        }
                        Image
                        {
                            id: imageItem
                            anchors.top: spacerItem1.bottom
                            source: model.source
                            height: 60
                            width: 60
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Rectangle
                        {
                            id: spacerItem2
                            anchors.top: imageItem.bottom
                            height: 16
                        }
                        Text
                        {
                            id: textItemMenu
                            anchors.top: spacerItem2.bottom
                            text: qsTr(name)
                            color: "#505559"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.family: "Roboto"
                            font.weight: componentItem.isPushed ? Font.Normal : Font.Light
                            font.pointSize: 16
                        }
                        Rectangle
                        {
                            id: spacerItem3
                            anchors.top: textItemMenu.bottom
                            height: 30
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered:
                            {
                                textItemMenu.font.weight = Font.Normal
                                if(!componentItem.isPushed) componentItem.color ="#B0B0B5"
                            }
                            onExited:
                            {
                                textItemMenu.font.weight = Font.Light
                                if(!componentItem.isPushed) componentItem.color = "transparent"
                            }

                            onClicked:
                            {
                                listViewTabs.currentIndex = index
                                stackViewScreenDashboard.setSource(Qt.resolvedUrl(page))
                            }
                        }

                        onIsPushedChanged: {
                            componentItem.color = (isPushed ? "#D0D3D6" : "transparent");
                        }
                    }
                    Rectangle
                    {
                        id: borderItem
                        height: 1
                        color: "#B5B5B5"
                        width: parent.width
                    }
                }
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

