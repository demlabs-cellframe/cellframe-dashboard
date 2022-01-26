import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root
    anchors.fill: parent

    property alias startServiceButton: startServiceButton

    ColumnLayout {
        anchors.fill: parent
        Button {
            id: startServiceButton
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Start service")
        }
    }
}
