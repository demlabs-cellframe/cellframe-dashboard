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
