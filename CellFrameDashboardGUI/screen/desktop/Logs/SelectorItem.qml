import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ColumnLayout
{
    id: main
    property alias text: textItem.text
    property bool current: true

    signal itemClicked()

    Text
    {
        id: textItem
        Layout.fillHeight: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        font: mainFont.dapFont.bold14
        color: current ? currTheme.white : currTheme.gray
        verticalAlignment: Qt.AlignVCenter
    }

    Rectangle
    {
        Layout.minimumHeight: 2
        width: textItem.width + 32
        color: current ? "#DBFF71" : "transparent"
    }

    MouseArea
    {
        anchors.fill: parent

        onClicked:
        {
            itemClicked()
        }
    }

}

