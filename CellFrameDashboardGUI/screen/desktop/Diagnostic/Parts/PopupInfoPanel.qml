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
        color: currTheme.backgroundMainScreen
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
        width: parent.width - 281 - 21 - 21
        height: 346
        x: 21
        y: -500
        radius: 12
        color:currTheme.backgroundElements

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
                color: currTheme.backgroundMainScreen

                //header
                RowLayout{
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12

                    spacing: 0

                    Text{

                        text: qsTr("System information ")
                        font: mainFont.dapFont.bold14
                        color: currTheme.textColor

                    }
                    Text{
                        text: qsTr("(You can select information you allow to send)")
                        font: mainFont.dapFont.bold14
                        color: currTheme.textColorGray

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
                    color: currTheme.lineSeparatorColor
                }
                //horizontal line
                Rectangle{
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 171
                    color: currTheme.lineSeparatorColor
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
                            content: system.mac_list.length > 1 ? system.mac_list[1]: system.mac_list[0]
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
                            _switch.visible: true
                            _switch.onCheckedChanged: diagnostic.flagSendSysTime = _switch.checked
                            Component.onCompleted: _switch.checked = diagnostic.flagSendSysTime
                        }
                        TextInfoElement{
                            title: qsTr("Dashboard uptime: ")
                            content: system.uptime_dashboard
                            _switch.visible: true
                            _switch.onCheckedChanged: diagnostic.flagSendDahsTime = _switch.checked
                            Component.onCompleted: _switch.checked = diagnostic.flagSendDahsTime
                        }
                        TextInfoElement{
                            title: qsTr("Memory: ")
                            content: system.memory.total
                            _switch.visible: true
                            _switch.onCheckedChanged: diagnostic.flagSendMemory = _switch.checked
                            Component.onCompleted: _switch.checked = diagnostic.flagSendMemory
                        }
                        TextInfoElement{
                            title: qsTr("Memory free: ")
                            content: system.memory.free
                            _switch.visible: true
                            _switch.onCheckedChanged: diagnostic.flagSendMemoryFree = _switch.checked
                            Component.onCompleted: _switch.checked = diagnostic.flagSendMemoryFree
                        }

                        Item{Layout.fillHeight: true}

                    }

                    ColumnLayout{
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 20

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 112
                        Layout.maximumHeight: 112

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
                        }
                        Item{Layout.fillHeight: true}
                    }


                    ColumnLayout{
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.topMargin: 20

                        Layout.minimumWidth: panelLayout.width/2 - 32
                        Layout.maximumWidth: panelLayout.width/2 - 32
                        Layout.minimumHeight: 112
                        Layout.maximumHeight: 112

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
