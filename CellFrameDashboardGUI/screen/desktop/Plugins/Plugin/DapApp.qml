import QtQuick 2.4
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import "Elements"

Rectangle {
    anchors.fill: parent
    color: "#2E3138"
    radius: 16 

    DapAppMainScreen
    {
        id: mainScreen
    }

    InnerShadow {
        id: topLeftSadow
        anchors.fill: mainScreen
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: mainScreen
        visible: mainScreen.visible
    }
    InnerShadow {
        anchors.fill: mainScreen
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: mainScreen.visible
    }
}
