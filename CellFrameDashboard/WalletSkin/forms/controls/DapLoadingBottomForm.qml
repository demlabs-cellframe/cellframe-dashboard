import QtQuick 2.4

Item {

    DapLoadIndicator {
//            x: parent.width / 2
//            y: parent.height / 2

        anchors.centerIn: parent

        indicatorSize: 64
        countElements: 8
        elementSize: 10

        running: !isModelLoaded
    }

}
