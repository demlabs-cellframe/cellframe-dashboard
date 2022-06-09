import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    height: 60

        Item
        {
            anchors.fill: parent

            Text {
                id: connectedText
                font: mainFont.dapFont.medium16
                color: currTheme.textColor

                text: qsTr("Connected to:")
            }

            Text {
                font: mainFont.dapFont.medium18
//                font.bold: true
                color: currTheme.textColor
                y: connectedText.height + 10 * pt

                text: qsTr("42.112.14.73 (San Juan, Puerto Rico)")
            }
        }

        DapButton
        {
            y: parent.height * 0.5 - height * 0.5 + 3 * pt
            x: parent.width - width
            width: 170 * pt
            height: 38 * pt
//            font.pointSize: 12
            horizontalAligmentText: Text.AlignHCenter
            fontButton: mainFont.dapFont.regular16
            textButton: qsTr("Disconnect")
        }

//    color: "transparent"
}
