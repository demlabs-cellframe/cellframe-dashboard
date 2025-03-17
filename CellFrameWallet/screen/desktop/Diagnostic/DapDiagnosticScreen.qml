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

    background: Rectangle { color: currTheme.mainBackground}

    DapRectangleLitAndShaded
    {
        id: mainFrame
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
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
                    color: currTheme.white
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
                model: diagnosticNodeModel
                cacheBuffer: 30000

                ScrollBar.vertical: ScrollBar{}

                delegate:
                ColumnLayout{
                    property bool isShow: true

                    id: layout
                    width: listViewDiagnostic.width
                    height: isShow ? 482 : 40
                    spacing: 20

                    Rectangle{
                        id: header
                        Layout.fillWidth: true
                        height: 40
                        color: currTheme.mainBackground

                        RowLayout{
                            anchors.fill: parent

                            Text{
                                Layout.alignment: Qt.AlignLeft
                                Layout.leftMargin: 16
                                font: mainFont.dapFont.medium13
                                color: currTheme.white
                                verticalAlignment: Text.AlignVCenter

                                text: system_node_name === "" ? system_mac : system_node_name
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Item {
                                Layout.alignment: Qt.AlignRight
                                Layout.leftMargin: 16
                                width: 190

                                Text{
                                    anchors.fill: parent
                                    font: mainFont.dapFont.medium13
                                    color: currTheme.gray
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignLeft

                                    text: qsTr("Last update: ") + system_time_update
                                }
                            }


                            Image{
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 16
                                rotation: layout.isShow? 180 : 0
                                source: "qrc:/Resources/" + pathTheme + "/icons/other/icon_arrowDown.svg"
                                mipmap: true
                                Behavior on rotation {NumberAnimation{duration: 200}}
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                layout.isShow = !layout.isShow
                            }
                        }
                    }

                    Item{
                        visible: layout.isShow
                        Layout.preferredHeight: 236
                        Layout.fillWidth: true

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 16

                            TextInfoElement{
                                title: qsTr("MAC address: ")
                                content: system_mac
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("System uptime: ")
                                content: system_uptime
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Wallet uptime: ")
                                content: system_uptime_dashboard
                                widthTitle: 156

                            }
                            TextInfoElement{
                                title: qsTr("CPU load: ")
                                content: system_CPU_load + " %"
                                progress.visible: true
                                progress.value: system_CPU_load
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("Memory usage: ")
                                content: system_memory_load + " %"
                                progress.visible: true
                                progress.value: system_memory_load
                                widthTitle: 156
                            }

                            TextInfoElement{
                                title: qsTr("Memory: ")
                                content: system_memory_total
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Memory free: ")
                                content: system_memory_free
                                widthTitle: 156
                            }
                        }
                    }

                    Rectangle{
                        visible: layout.isShow
                        Layout.fillWidth: true
                        height: 1
                        color:currTheme.mainBackground

                    }

                    RowLayout{
                        visible: layout.isShow
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
                                content: proc_version
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("Node uptime: ")
                                content: proc_uptime
                                widthTitle: 156
                            }
                            TextInfoElement{
                                widthTitle: 156
                                title: qsTr("Node status: ")
                                content: proc_status
                                contentColor: proc_status === "Online" ? currTheme.lightGreen
                                                                       : currTheme.red

                            }
                            TextInfoElement{
                                title: qsTr("Node RSS: ")
                                content: proc_memory_use + " %"
                                progress.visible: true
                                progress.value: proc_memory_use
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
                                content: proc_log_size
                                widthTitle: 156
                            }
                            TextInfoElement{
                                title: qsTr("DB size: ")
                                content: proc_DB_size
                                widthTitle: 156
                            }
                            TextInfoElement{
                                widthTitle: 156
                                title: qsTr("Chain size: ")
                                content: proc_chain_size
                            }
                            TextInfoElement{
                                title: qsTr("Node RSS: ")
                                content: proc_memory_use_value
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
