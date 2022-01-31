import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root
    anchors.fill: parent

    background: Rectangle {

    }

    property alias startServiceButton: startServiceButton

    Button {
        id: startServiceButton
        width: 250
        height: 100
        anchors.left: root.left
        anchors.top: root.top
        text: qsTr("Start service")
    }
}
