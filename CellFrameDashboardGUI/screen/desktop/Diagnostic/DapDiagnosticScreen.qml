import QtQuick.Window 2.2
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../controls"
import "qrc:/widgets"

Page
{
    id: dapDiagnosticScreen

    background: Rectangle { color: currTheme.backgroundMainScreen}

    DapRectangleLitAndShaded
    {
        id: mainFrameTokens
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
                    text: qsTr("Nodes")
                }
            }

            ListView
            {
                id: listViewDiagnostic
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: diagnosticDataModel

                delegate:
                ColumnLayout{
                    width: listViewDiagnostic.width
                    height: listViewDiagnostic.height
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: currTheme.backgroundElements

                        Rectangle{
                            width: parent.width
                            height: 20

                            Text{
                                text: "System data"
                            }
                        }

                        RowLayout{
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 80

                            ColumnLayout{
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout{
                                    Text{
                                        text: "MAC address: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.mac_list.length > 1 ? system.mac_list[1]: system.mac_list[0]
                                    }
                                }

                                RowLayout{
                                    Text{
                                        text: "System uptime: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.uptime.time
                                    }
                                }

                                RowLayout{
                                    Text{
                                        text: "CPU name: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.CPU.model
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "CPU load: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.CPU.load + " %"
                                    }
                                }
                            }

                            ColumnLayout{
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                RowLayout{
                                    Text{
                                        text: "Dashboard uptime: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.uptime_dashboard
                                    }
                                }

                                RowLayout{
                                    Text{
                                        text: "Memory usage: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.memory.load + " %"
                                    }
                                }

                                RowLayout{
                                    Text{
                                        text: "Memory: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                        text: system.memory.total
                                    }
                                }

                                RowLayout{
                                    Text{
                                        text: "Memory free: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: system.memory.free
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                            }
                        }
                    }
                    Rectangle{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: currTheme.backgroundElements

                        Rectangle{
                            width: parent.width
                            height: 20

                            Text{
                                text: "Node data"
                            }
                        }

                        RowLayout{
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 80


                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout{
                                    Text{
                                        text: "Node version: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.version
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "Node uptime: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.uptime
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "Node status: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.status
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "Node path: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.path
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                            }

                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                RowLayout{
                                    Text{
                                        text: "Log size: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.log_size
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "DB size: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.DB_size
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                                RowLayout{
                                    Text{
                                        text: "Chain size: "
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                    Text{
                                        text: process.chain_size
                                        font: mainFont.dapFont.medium12
                                        color: currTheme.textColor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
