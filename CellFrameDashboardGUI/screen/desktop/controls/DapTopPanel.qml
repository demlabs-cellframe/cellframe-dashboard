import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Page
{
    id: control
    height: 60
    background: Rectangle {
        color: "transparent"
    }

    state: modulesController.isNodeWorking ? "READY" : "LOADING"
    states: [
        State {
            name: "LOADING"
            PropertyChanges { target: beckgrndRect; visible: false }
            PropertyChanges { target: frontRect; visible: true }
        },
        State {
            name: "READY"
            PropertyChanges { target: beckgrndRect; visible: true }
            PropertyChanges { target: frontRect; visible: false }
        }
    ]

    Rectangle {
        id: beckgrndRect
        anchors.fill: parent
        anchors.leftMargin: 3
        radius: 16
        color: currTheme.mainBackground

        Rectangle {
            height: control.height
            width: 50
            color: parent.color
            anchors {
                top: parent.top
                right: parent.right
            }
        }

        Rectangle {
            id: leftRect
            width: 50
            height: parent.height - parent.radius
            color: parent.color
            anchors {
                top: parent.top
                left: parent.left
            }
        }
        InnerShadow {
            anchors.fill: leftRect
            radius: 0
            samples: 16
            horizontalOffset: 1
            color: "#4C4B5A"
            source: leftRect
        }
    }

    // TOP - TOP Panel
    // Show while node loading
    Rectangle
    {
        id: frontRect
        anchors.fill: parent
        anchors.leftMargin: 3
        radius: 16
        color: currTheme.mainBackground
        z: control.z + 1

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
            source: "qrc:/Resources/" + pathTheme + "/icons/other/loader_orange.svg"
            z: parent.z + 1

            RotationAnimator
            {
                target: loader
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: true
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
            text: qsTr("The node is currently being launched ") + modulesController.nodeLoadProgress + "/100%"
        }

        Rectangle
        {
            id: progressBar
            width: frontRect.width / 100 * modulesController.nodeLoadProgress
            height: 4
            color: currTheme.orange
            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        Rectangle
        {
            height: control.height
            width: 50
            color: parent.color
            anchors {
                top: parent.top
                right: parent.right
            }
        }

        Rectangle
        {
            id: frontLeftRect
            width: 50
            height: parent.height - parent.radius
            color: parent.color
            anchors {
                top: parent.top
                left: parent.left
            }
        }
        InnerShadow
        {
            anchors.fill: frontLeftRect
            radius: 0
            samples: 16
            horizontalOffset: 1
            color: "#4C4B5A"
            source: frontLeftRect
        }
    }

    DropShadow {
        anchors.fill: beckgrndRect
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: currTheme.shadowColor
        source: beckgrndRect
    }

    InnerShadow {
        anchors.fill: beckgrndRect
        radius: 0
        samples: 16
        horizontalOffset: 1
        color: "#4C4B5A"
        source: beckgrndRect
    }
}
