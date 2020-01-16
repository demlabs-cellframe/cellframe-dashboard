import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import "../../"

DapAbstractScreen
{
    Rectangle
    {
        anchors.fill: parent
        anchors.topMargin: 24 * pt
        anchors.leftMargin: 20 * pt
        anchors.rightMargin: 20 * pt

        ListView
        {
            id: listViewConsoleCommand
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: inputCommand.top
            clip: true
            model: modelConsoleCommand
            delegate: delegateConsoleCommand
        }

        RowLayout
        {
            id: inputCommand

            spacing: 0

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Text
            {
                id: promt
                verticalAlignment: Qt.AlignVCenter
                text: ">"
                color: "#070023"
                font.pixelSize: 18 * pt
                font.family: "Roboto"
                font.weight: Font.Normal
            }

            TextArea
            {
                id: consoleCmd
                Layout.fillWidth: true
                wrapMode: TextArea.Wrap
                placeholderText: qsTr("Type here...")
                selectByMouse: true
                focus: true
                font.pixelSize: 18 * pt
                font.family: "Roboto"
                font.weight: Font.Normal
            }
        }
    }
}
