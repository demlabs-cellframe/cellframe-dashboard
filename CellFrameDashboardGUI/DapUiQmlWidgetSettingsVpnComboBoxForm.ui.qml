import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

ComboBox {
    background: Rectangle {
        anchors.fill: parent
        border.color: "#707070"
        border.width: 1
        radius: parent.width / 2
    }

    contentItem: Text {
        anchors.fill: parent
        anchors.leftMargin: 12 * pt
        anchors.rightMargin: 52 * pt
        text: parent.displayText
        font.family: "Regular"
        font.pixelSize: 14 * pt
        color: "#A7A7A7"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    DropShadow {
        anchors.fill: parent
        source: parent.background
        verticalOffset: 4 * pt
        samples: 13 * pt
        color: "#40000000"
    }
}
