import QtQuick.Window 2.2
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../controls"
import "qrc:/widgets"
import "Parts"

Page
{
    id: dapDiagnosticScreen

    background: Rectangle { color: currTheme.backgroundMainScreen}

    ListModel{
        id: testModel

        Component.onCompleted: {

            testModel.append(diagnosticDataModel.get(0))
            testModel.append(diagnosticDataModel.get(0))
        }
    }

    DapRectangleLitAndShaded
    {
        id: mainFrame
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
        {
            anchors.fill: parent
            spacing: 0

            Item
            {
                id: tokensShowHeader
                Layout.fillWidth: true
                height: 42
                Text
                {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    font: mainFont.dapFont.bold14
                    color: currTheme.textColor
                    verticalAlignment: Qt.AlignVCenter
                    text: qsTr("Diagnostics")
                }
            }

            ListView
            {
                id: listViewDiagnostic
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: testModel

                delegate:
                    ColumnLayout{

                    id: layout
                    width: listViewDiagnostic.width
                    height: header.isShow ? 482 : 40
                    spacing: 20

                    Rectangle{
                        property bool isShow: true
                        id: header
                        Layout.fillWidth: true
                        height: 40
                        color: currTheme.backgroundMainScreen

                        RowLayout{
                            anchors.fill: parent

                            Text{
                                Layout.alignment: Qt.AlignLeft
                                Layout.leftMargin: 16
                                font: mainFont.dapFont.medium13
                                color: currTheme.textColor
                                verticalAlignment: Text.AlignVCenter

                                text: system.mac_list.length > 1 ? system.mac_list[1]: system.mac_list[0]

                            }

                            Image{
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 16
                                rotation: header.isShow? 180 : 0
                                source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                                mipmap: true
                                Behavior on rotation {NumberAnimation{duration: 200}}
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                header.isShow = !header.isShow
                            }
                        }

                    }

                    Item{
                        visible: header.isShow
                        Layout.preferredHeight: 236
                        Layout.fillWidth: true

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 16

                            TextInfoElement{
                                title: qsTr("MAC address: ")
                                content: system.mac_list.length > 1 ? system.mac_list[1]: system.mac_list[0]
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("System uptime: ")
                                content: system.uptime
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Dashboard uptime: ")
                                content: system.uptime_dashboard
                                widthTitle: 156

                            }
                            TextInfoElement{
                                title: qsTr("CPU load: ")
                                content: system.CPU.load + " %"
                                progress.visible: true
                                progress.value: system.CPU.load
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("Memory usage: ")
                                content: system.memory.load + " %"
                                progress.visible: true
                                progress.value: system.memory.load
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("Memory: ")
                                content: system.memory.total
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Memory free: ")
                                content: system.memory.free
                                widthTitle: 156
                            }
                        }
                    }

                    Rectangle{
                        visible: header.isShow
                        Layout.fillWidth: true
                        height: 1
                        color:currTheme.lineSeparatorColor

                    }

                    RowLayout{
                        visible: header.isShow
                        Layout.preferredHeight: 128
                        Layout.fillWidth: true
                        Layout.leftMargin: 16
                        Layout.rightMargin: 130
                        spacing: 0

                        ColumnLayout{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            spacing: 16

                            TextInfoElement{
                                title: qsTr("Node version: ")
                                content: process.version
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Node uptime: ")
                                content: process.uptime
                                widthTitle: 156
                            }
                            TextInfoElement{
                                widthTitle: 156
                                title: qsTr("Node status: ")
                                content: process.status
                                contentColor: process.status === "Online" ? currTheme.progressBarColor1
                                                                          : currTheme.progressBarColor3

                            }
                            TextInfoElement{
                                title: qsTr("Node RSS: ")
                                content: process.memory_use + " %"
                                progress.visible: true
                                progress.value: process.memory_use
                                widthTitle: 156
                            }

                        }

                        Item{Layout.fillWidth: true}

                        ColumnLayout{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            spacing: 16

                            TextInfoElement{
                                Layout.fillWidth: true
                                title: qsTr("Log size: ")
                                content: process.log_size
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("DB size: ")
                                content: process.DB_size
                                widthTitle: 156
                            }
                            TextInfoElement{
                                widthTitle: 156
                                title: qsTr("Chain size: ")
                                content: process.chain_size
                            }
                            TextInfoElement{
                                title: qsTr("Node RSS: ")
                                content: process.memory_use_value
                                widthTitle: 156
                            }

                        }
                    }

                    Item{height: 20}
                }
            }
        }
    }
}
