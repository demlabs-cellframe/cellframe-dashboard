import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Component {

    Rectangle {
        width:  parent.width
        height: 30 * pt
        color: "#DFE1E6"

        Text {
            id: dateText
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignLeft
            color: "#5F5F63"
            text: section
            font.family: "Regular"
            font.pixelSize: 12 * pt
            leftPadding: 30 * pt
        }
    }
}
