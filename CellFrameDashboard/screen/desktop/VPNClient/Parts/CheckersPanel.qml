import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
    height: 40 * pt

    RowLayout
    {
        anchors.fill: parent
        //anchors.margins: 10 * pt

        spacing: 10 * pt

        Image
        {
            width: 10 * pt
            height: 10 * pt
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text
        {
            Layout.fillWidth: true
            color: currTheme.textColor
            font: mainFont.dapFont.regular13

            text: qsTr("Connection established")
        }

        Image
        {
            width: 10 * pt
            height: 10 * pt
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text
        {
            Layout.fillWidth: true
            color: currTheme.textColor
            font: mainFont.dapFont.regular13

            text: qsTr("IP requested")
        }

        Image {
            width: 10 * pt
            height: 10 * pt
            fillMode: Image.PreserveAspectFit

            source: "qrc:/screen/desktop/VPNClient/Images/check.png"
        }

        Text {
            color: currTheme.textColor
            font: mainFont.dapFont.regular13

            text: qsTr("Virtual network interface")
        }

    }

}
