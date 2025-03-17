import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Item {
    id: popupInfoSystem
    anchors.fill: parent
    visible: false

    Rectangle{
        id: background
        anchors.fill: parent
        color: currTheme.mainBackground
        opacity: 0

        Behavior on opacity {NumberAnimation{duration: 200}}
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onWheel: {}
        enabled: parent.visible
        visible: parent.visible
    }
    Rectangle{
        id: contentPanel
        width: parent.width - 257 - 21 - 21
        height: 374
        x: 21
        y: -500
        radius: 12
        color: currTheme.secondaryBackground

        Behavior on y {NumberAnimation{duration: 200}}

        /* mask source */
        Rectangle {
            id: contenMask
            anchors.fill: parent
            radius: 12
            visible: false
        }
        /* mask */
        OpacityMask {
            anchors.fill: layout
            source: layout
            maskSource: contenMask
        }

        ColumnLayout{
            id: layout
            anchors.fill: parent
            spacing: 0
            opacity: 0

            Rectangle{
                height: 42
                Layout.fillWidth: true
                color: currTheme.mainBackground

                //header
                RowLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12

                    spacing: 0

                    Text{

                        text: qsTr("System information")
                        font: mainFont.dapFont.bold14
                        color: currTheme.white

                    }
                    Item{Layout.fillWidth: true}
                }
            }

            ListView{
                id: panelLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: diagnosticDataModel

                clip: false
                interactive: false

                spacing: 0

                //vertical line
                Rectangle{
                    width: 1
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: currTheme.mainBackground
                }
                //horizontal line
                Rectangle{
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 171
                    color: currTheme.mainBackground
                }

                delegate:
                    GridLayout{
                    width: panelLayout.width
                    height: panelLayout.height
                    x:0
                    y:0

                    rows: 2
                    columns: 2
                    rowSpacing: 0
                    columnSpacing: 0

                    ColumnLayout{
                        Layout.alignment: Qt.AlignTop
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 20

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 151
                        Layout.maximumHeight: 151

                        Layout.row: 0
                        Layout.column: 0

                        spacing: 16

                        TextInfoElement{
                            title: qsTr("MAC address: ")
                            content: system.mac
                        }

                        TextInfoElement{
                            title: qsTr("CPU load: ")
                            content: system.CPU.load + " %"
                            progress.visible: true
                            progress.value: system.CPU.load
                        }

                        TextInfoElement{
                            title: qsTr("Memory usage: ")
                            content: system.memory.load + " %"
                            progress.visible: true
                            progress.value: system.memory.load
                        }

                        Item{Layout.fillHeight: true}
                    }

                    ColumnLayout{
                        Layout.alignment: Qt.AlignTop
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 15

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 156
                        Layout.maximumHeight: 156

                        spacing: 10

                        TextInfoElement{
                            title: qsTr("System uptime: ")
                            content: system.uptime
                        }
                        TextInfoElement{
                            title: qsTr("Wallet uptime: ")
                            content: system.uptime_dashboard
                        }
                        TextInfoElement{
                            title: qsTr("Memory: ")
                            content: system.memory.total
                        }
                        TextInfoElement{
                            title: qsTr("Memory free: ")
                            content: system.memory.free
                        }

                        Item{Layout.fillHeight: true}

                    }

                    ColumnLayout{
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 20

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 148
                        Layout.maximumHeight: 148

                        spacing: 16

                        TextInfoElement{
                            title: qsTr("Node version: ")
                            content: process.version
                        }
                        TextInfoElement{
                            title: qsTr("Node uptime: ")
                            content: process.uptime
                        }
                        TextInfoElement{
                            title: qsTr("Node status: ")
                            content: process.status
                            contentColor: process.status === "Online" ? currTheme.lightGreen
                                                                      : currTheme.red

                        }
                        TextInfoElement{
                            title: qsTr("Node RSS: ")
                            content: process.memory_use + " %"
                            progress.visible: true
                            progress.value: process.memory_use
                        }

                        Item{Layout.fillHeight: true}
                    }


                    ColumnLayout{
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 20

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 148
                        Layout.maximumHeight: 148

                        spacing: 16

                        TextInfoElement{
                            title: qsTr("Log size: ")
                            content: process.log_size
                        }
                        TextInfoElement{
                            title: qsTr("DB size: ")
                            content: process.DB_size
                        }
                        TextInfoElement{
                            title: qsTr("Chain size: ")
                            content: process.chain_size
                        }
                        TextInfoElement{
                            title: qsTr("Node RSS: ")
                            content: process.memory_use_value
                        }
                        Item{Layout.fillHeight: true}
                    }
                }
            }
        }
    }

    DropShadow {
        anchors.fill: contentPanel
        horizontalOffset: currTheme.hOffset
        verticalOffset: currTheme.vOffset
        radius: currTheme.radiusShadow
        color: currTheme.shadowColor
        source: contentPanel
        spread: 0.1
        smooth: true
    }

    InnerShadow {
        id: light
        anchors.fill: contentPanel
        horizontalOffset: 1
        verticalOffset: 1
        radius: 0
        samples: 10
        cached: true
        color: currTheme.reflectionLight
        source: contentPanel
        visible: contentPanel.visible
    }

    Timer{id:timer}

    function show(isShow){

        if(isShow)
            popupInfoSystem.visible = isShow
        else
            delay(200, function(){
                popupInfoSystem.visible = isShow
            })

        background.opacity = isShow? 0.72: 0
        contentPanel.y = isShow? 8: -500
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }
}
