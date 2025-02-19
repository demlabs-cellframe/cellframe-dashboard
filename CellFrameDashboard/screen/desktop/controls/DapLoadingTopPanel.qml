import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

DapTopPanel
{
    property int percentLoading: modulesController.nodeLoadProgress
    property bool isNodeWorking: modulesController.isNodeWorking
    property bool doneDelay: false

    id: control
    height: 60
    visible: !isNodeWorking || doneDelay
    anchors.fill: parent
    z: parent.z + 10

    Rectangle
    {
        id: backgrndRect
        anchors.fill: parent
        anchors.leftMargin: 3
        radius: 16
        color: currTheme.mainBackground

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: backgrndRect.width
                height: backgrndRect.height
                Rectangle {
                    anchors.centerIn: parent
                    width: backgrndRect.width
                    height: backgrndRect.height
                    radius: 16
                    Rectangle {
                        height: backgrndRect.height
                        width: backgrndRect.width / 2
                        anchors.right: parent.right
                    }
                }
            }
        }

        Image
        {
            id: loader
            width: 24
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            sourceSize: Qt.size(24,24)
            smooth: true
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            source: {
                if(app.getNodeMode() === 0)
                {
                    if(!cellframeNodeWrapper.nodeServiceLoaded)
                        return "qrc:/Resources/" + pathTheme + "/icons/other/disabled-node_icon.svg"
                    else if (percentLoading >= 100 || doneDelay)
                        return "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.svg"
                    else
                        return "qrc:/Resources/" + pathTheme + "/icons/other/loader_orange.svg"
                }
                else
                    return "qrc:/Resources/" + pathTheme + "/icons/other/loader_orange.svg"
            }

            z: parent.z + 1

            RotationAnimator
            {
                target: loader
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running:
                {
                    if(app.getNodeMode() === 0)
                        return percentLoading < 100 && !doneDelay && cellframeNodeWrapper.nodeServiceLoaded
                    return false
                }

                onStopped: {
                    loader.rotation = 0;
                }
            }
        }

        Text
        {
            id: nodeLoadingText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 56
            font: mainFont.dapFont.regular14
            color: currTheme.white
            text: {
                if(app.getNodeMode() === 0)
                {
                    if(!cellframeNodeWrapper.nodeServiceLoaded)
                        return qsTr("The node services are disabled. They can be enabled in the Settings tab.")
                    else if(percentLoading >= 100 || doneDelay)
                        return qsTr("The node has loaded")
                    else if(percentLoading)
                        return qsTr("The node is currently being launched ") + percentLoading + "/100%"
                    else if(cellframeNodeWrapper.nodeInstalled)
                        return qsTr("The node is currently being launched. Receving data from the node")
                    else
                        return qsTr("Node is not installed")
                }
                return ""
            }

        }

        Rectangle
        {
            id: progressBar
            width: doneDelay ? backgrndRect.width : backgrndRect.width / 100 * percentLoading
            height: 4
            color: percentLoading < 100 && !doneDelay ? currTheme.orange : currTheme.lime
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        MouseArea
        {
            enabled: !isNodeWorking || doneDelay
            anchors.fill: parent
            hoverEnabled: true
            onClicked:
            {
                console.log("Wait loading node.")
            }
            onHoveredChanged: {}
        }
    }

    Connections
    {
        target: modulesController
        function onNodeWorkingChanged()
        {
            if(modulesController.isNodeWorking && !modulesController.isFirstLaunch())
            {
                doneDelay = true
                delayTimer.start()
            }
        }
    }

    Timer
    {
        id: delayTimer
        interval: 3000
        onTriggered: doneDelay = false
    }
}
