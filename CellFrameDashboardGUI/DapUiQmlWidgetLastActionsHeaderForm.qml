import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    width: parent.width
    height: 36 * pt
    color: "#EDEFF2"

    Item {
        width: childrenRect.width
        height: childrenRect.height
        anchors.top: parent.top
        anchors.left: parent.left

        anchors.leftMargin: 16 * pt
        anchors.topMargin: 13

        Text {
            text: qsTr("Last actions")
            font.family: "Roboto"
            font.pixelSize: 12 * pt
            color: "#5F5F63"
        }
    }
}
