import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Component {
//    id: dapDate
    Rectangle {
        width:  dapListView.width
        height: 30 * pt
        color: "#C2CAD1"

        Text {
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignLeft
            color: "#797979"
            text: section
            font.family: "Roboto"
            font.pixelSize: 12 * pt
            leftPadding: 16 * pt
        }
    }
}
