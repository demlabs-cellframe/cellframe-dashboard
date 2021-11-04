import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Button {
    id: control

    background: Item {
        id: dapBackgroundButton
        Rectangle {

            anchors.fill: parent
            radius: 20
            LinearGradient
            {
                anchors.fill: parent
                source: parent
                start: Qt.point(0,parent.height/2)
                end: Qt.point(parent.width,parent.height/2)
                gradient:
                    Gradient {
                    GradientStop { position: 0; color: control.hovered ? "#E62083" : "#C91D73" }
                    GradientStop { position: 1; color: control.hovered ? "#E62263" : "#D51F5D" }
                }
            }

        }
    }

    contentItem: Text {
        id: buttonText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "Test"
        color: "white"
    }

    DropShadow {
        anchors.fill: dapBackgroundButton
        visible: !control.down
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        samples: 32
        color: "#2A2C33"
        source: dapBackgroundButton
        smooth: true
    }

    MouseArea {
        enabled: false
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }
}
