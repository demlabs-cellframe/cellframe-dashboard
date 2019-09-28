import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Rectangle {
    color: "#EDEFF2"

    Text {
        anchors.fill: parent
        anchors.leftMargin: 16 * pt
        text: qsTr("Last actions")
        verticalAlignment: Qt.AlignVCenter
        font.family: "Roboto"
        font.pixelSize: 12 * pt
        color: "#5F5F63"
    }
}
