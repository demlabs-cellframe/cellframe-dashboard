import QtQuick 2.0
import QtQuick.Layouts 1.4

Rectangle{
    color: currTheme.backgroundMainScreen
    anchors.fill: parent

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: 520
        height: 400
        color: "transparent"

        Image {
            id: under_cunstruct_img
            anchors.fill: parent
            source: "qrc:/resources/icons/" + pathTheme + "/under construction.png"
            anchors.centerIn: parent.Center
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
    }
}
