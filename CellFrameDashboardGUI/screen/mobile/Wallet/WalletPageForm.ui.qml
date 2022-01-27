import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root
    anchors.fill: parent

    property alias startServiceButton: startServiceButton

    Button {
        id: startServiceButton
        width: 150
        height: 100
        anchors.centerIn: parent
        text: qsTr("Start service")
    }
}
