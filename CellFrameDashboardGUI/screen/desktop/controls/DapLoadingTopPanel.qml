import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

DapTopPanel
{
    property int percentLoading: modulesController.nodeLoadProgress
    property bool isNodeWorking: modulesController.isNodeWorking

    id: control
    height: 60
    visible: !isNodeWorking
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
            source: percentLoading >= 100 ? "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.svg" : "qrc:/Resources/" + pathTheme + "/icons/other/loader_orange.svg"
            z: parent.z + 1

            RotationAnimator
            {
                target: loader
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: percentLoading < 100
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
            text: percentLoading >= 100 ? qsTr("The node has loaded") :
                      percentLoading ? qsTr("The node is currently being launched ") + percentLoading + "/100%":
                                                       qsTr("The node is currently being launched. Waiting for node data to be received")
        }

        Rectangle
        {
            id: progressBar
            width: backgrndRect.width / 100 * percentLoading
            height: 4
            color: percentLoading < 100 ? currTheme.orange : currTheme.lime
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        MouseArea
        {
            enabled: !isNodeWorking
            anchors.fill: parent
            hoverEnabled: true
            onClicked:
            {
                console.log("Wait loading node.")
            }
            onHoveredChanged: {}
        }
    }
}
