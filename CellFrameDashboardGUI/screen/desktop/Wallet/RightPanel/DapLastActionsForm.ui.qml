import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    background: Rectangle {
        color: "transparent"//currTheme.backgroundElements
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "green"
        anchors.margins: 10
    }

    Rectangle {
        anchors.centerIn: parent
        height: 100
        width: 100
        color: "red"
    }
}
