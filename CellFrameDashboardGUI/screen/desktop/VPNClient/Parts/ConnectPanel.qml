import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    height: 80

    RowLayout
    {
        anchors.fill: parent
        spacing: 10

        ColumnLayout
        {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 10

            Text {
                Layout.fillWidth: true
                font: mainFont.dapFont.medium16
                color: currTheme.textColor

                text: qsTr("Connected to:")
            }

            Text {
                Layout.fillWidth: true
                font: mainFont.dapFont.medium18
//                font.bold: true
                color: currTheme.textColor

                text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
            }
        }

        DapButton
        {
            Layout.minimumWidth: 150 * pt
            Layout.minimumHeight: 36 * pt
//            font.pointSize: 12
            horizontalAligmentText: Text.AlignHCenter
            fontButton: mainFont.dapFont.regular16
            textButton: qsTr("Disconnect")
        }
    }

//    color: "transparent"
}
