import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    title: qsTr("Coming soon")

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/mobile/Icons/ComingSoon.png"
//        anchors.centerIn: parent
    }
}
