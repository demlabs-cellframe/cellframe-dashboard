import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    title: qsTr("Coming soon")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    Image {
        anchors.fill: parent
        anchors.margins: 20 * pt
        fillMode: Image.PreserveAspectFit
        source: "qrc:/screen/mobile_new/android/Icons/ComingSoon.png"
//        anchors.centerIn: parent
    }
}
