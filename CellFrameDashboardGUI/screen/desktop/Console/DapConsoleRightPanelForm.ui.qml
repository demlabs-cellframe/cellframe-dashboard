import QtQuick 2.4
import "../../"

DapAbstractRightPanel
{
    dapHeaderData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pixelSize: 12 * pt
                color: "#3E3853"
            }

            Rectangle
            {
                id: borderBottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: "#757184"
            }
        }


    dapContentItemData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"
            anchors.margins: 16 * pt

            ListView
            {
                id: listViewHistoryConsole
                anchors.fill: parent
                spacing: 32 * pt
                model: modelHistoryConsole
                delegate:
                    Text
                    {
                        id: textCommand
                        text: query
                        color: "#070023"
                        font.pixelSize: 14 * pt
                        font.family: "Roboto"
                        font.weight: Font.Normal
                    }
            }
        }
}
