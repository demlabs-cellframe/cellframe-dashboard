import QtQuick 2.4
import "qrc:/widgets"
import "../../"

DapRightPanel
{
    dapHeaderData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Text
            {
                anchors.fill: parent
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 24 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandBold14
                color: currTheme.textColor
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
                        color: currTheme.textColor
                        width: parent.width
                        wrapMode: Text.Wrap
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
                        //For the automatic sending selected command from history
                        MouseArea
                        {
                            id: historyQueryMouseArea
                            anchors.fill: textCommand
                            onDoubleClicked: historyQueryIndex = index
                        }
                    }
                //It allows to see last element of list by default
                currentIndex: count - 1
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange
            }
        }
}
