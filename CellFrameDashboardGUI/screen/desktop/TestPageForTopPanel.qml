import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    id: root

    background: Rectangle {
        color: "transparent"
    }

    RowLayout {
        anchors.fill: parent
        Text {
            text: qsTr("text")
            color: "white"
        }
    }
}
