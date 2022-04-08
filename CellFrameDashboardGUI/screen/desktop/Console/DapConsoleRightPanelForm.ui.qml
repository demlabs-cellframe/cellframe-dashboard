import QtQuick 2.9
import QtQuick.Controls 2.5
import "qrc:/widgets"
import "../../"

DapRightPanel
{
    dapHeaderData:
        Rectangle
        {
            color: "transparent"
            height: 38 * pt
            width: 348*pt

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 24 * pt
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }


    dapContentItemData:

        ListView
        {
            id: listViewHistoryConsole
            anchors.fill: parent
            clip: true
            spacing: 32 * pt
            model: modelHistoryConsole
            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
                Item
                {
                    anchors.leftMargin: 5 * pt
                    anchors.rightMargin: 5 * pt
                    width: listViewHistoryConsole.width
                    height: textCommand.implicitHeight
                    Text
                    {
                        anchors.fill: parent
                        anchors.rightMargin: 20 * pt
                        anchors.leftMargin: 16 * pt

                        id: textCommand
                        text: query
                        color: currTheme.textColor

                        wrapMode: Text.Wrap
                        font: mainFont.dapFont.regular14
                        //For the automatic sending selected command from history
                        MouseArea
                        {
                            id: historyQueryMouseArea
                            anchors.fill: textCommand
                            onDoubleClicked: historyQueryIndex = index
                        }
                    }
                }
            //It allows to see last element of list by default
            currentIndex: count - 1
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.ApplyRange
        }

//        Rectangle
//        {
//            anchors.fill: parent
//            color: "transparent"
//            anchors.margins: 16 * pt

//            ListView
//            {
//                id: listViewHistoryConsole
//                anchors.fill: parent
//                spacing: 32 * pt
//                model: modelHistoryConsole
//                delegate:
//                    Text
//                    {
//                        id: textCommand
//                        text: query
//                        color: currTheme.textColor
//                        width: parent.width
//                        wrapMode: Text.Wrap
//                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular14
//                        //For the automatic sending selected command from history
//                        MouseArea
//                        {
//                            id: historyQueryMouseArea
//                            anchors.fill: textCommand
//                            onDoubleClicked: historyQueryIndex = index
//                        }
//                    }
//                //It allows to see last element of list by default
//                currentIndex: count - 1
//                highlightFollowsCurrentItem: true
//                highlightRangeMode: ListView.ApplyRange
//            }
//        }
}
