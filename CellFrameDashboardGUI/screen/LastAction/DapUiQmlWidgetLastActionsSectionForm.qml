import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    color: "#757184"

    Text {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignLeft
        color: "#FFFFFF"
        text: section
        font.family: fontRobotoRegular.name
        font.pixelSize: 12 * pt
        leftPadding: 16 * pt
    }
}
