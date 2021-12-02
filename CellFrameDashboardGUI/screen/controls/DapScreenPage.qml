import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Page {
    id: root

    property bool frameVisible: true

    background: Rectangle {
        radius: 16 * pt
        color: currTheme.backgroundMainScreen
    }

    contentItem: Rectangle {
        id: frame
        visible: frameVisible
        anchors.fill: parent
        anchors.margins: 12 * pt
        color: currTheme.backgroundElements
        radius: 16 * pt

        InnerShadow {
            id: topLeftSadow
            anchors.fill: frame
            cached: true
            horizontalOffset: 5
            verticalOffset: 5
            radius: 4
            samples: 32
            color: "#2A2C33"
            smooth: true
            source: frame
        }
        InnerShadow {
            anchors.fill: frame
            cached: true
            horizontalOffset: -1
            verticalOffset: -1
            radius: 1
            samples: 32
            color: "#4C4B5A"
            source: topLeftSadow
        }
    }
}
