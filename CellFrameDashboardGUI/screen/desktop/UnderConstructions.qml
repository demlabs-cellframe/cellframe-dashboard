import QtQuick 2.0
import QtQuick.Layouts 1.4

Rectangle{
    color: currTheme.backgroundMainScreen
    anchors.fill: parent

    Rectangle{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: 500
        height: 210.8
        color: "transparent"

        Image {
            id: under_cunstruct_img
            anchors.fill: parent
            source: "qrc:/resources/icons/" + pathTheme + "/Illustratons/comingsoon_illustration.png"
            anchors.centerIn: parent.Center
            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
    }
}
