import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    height: 40

    RowLayout
    {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Image {
            width: 10
            height: 10
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text {
            Layout.fillWidth: true
            font.pointSize: 10
            color: "white"

            text: qsTr("Connection established")
        }

        Image {
            width: 10
            height: 10
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text {
            Layout.fillWidth: true
            font.pointSize: 10
            color: "white"

            text: qsTr("IP requested")
        }

        Image {
            width: 10
            height: 10
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text {
            Layout.fillWidth: true
            font.pointSize: 10
            color: "white"

            text: qsTr("Virtual network interface")
        }

    }

    color: "blue"
}
