import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    color: "#757184"

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1
        color: "#F8F7FA"

        Text {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            text: qsTr("Last actions")
            verticalAlignment: Qt.AlignVCenter
            font.family: fontRobotoRegular.name
            font.pixelSize: 12 * pt
            color: "#3E3853"
        }
    }
}
