import QtQuick 2.0

Component {

    Rectangle {
        width: parent.width
        height: 30 * pt
        color: "#DFE1E6"

        Text {
            anchors.fill: parent
            anchors.leftMargin: 18 * pt
            verticalAlignment: Qt.AlignVCenter
            text: section
            font.family: "Roboto"
            font.pixelSize: 12 * pt
            color: "#5F5F63"
        }
    }

}
