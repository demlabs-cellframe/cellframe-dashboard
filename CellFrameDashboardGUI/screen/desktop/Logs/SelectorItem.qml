import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ColumnLayout
{
    id: main
    property alias text: textItem.text
    property bool current: true
    property int margin: 26

    signal itemClicked()

    Text
    {
        id: textItem
        Layout.fillHeight: true
        Layout.leftMargin: margin
        Layout.rightMargin: margin
        font: mainFont.dapFont.bold14
        color: current ? currTheme.white : currTheme.gray
        verticalAlignment: Qt.AlignVCenter

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                itemClicked()
            }
        }
    }

    Rectangle
    {
        Layout.minimumHeight: 2
        width: textItem.width + margin*2
        color: current ? "#DBFF71" : "transparent"
    }
}
