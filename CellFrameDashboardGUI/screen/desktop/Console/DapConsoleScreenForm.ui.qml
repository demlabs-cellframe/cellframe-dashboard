import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    id: consoleScreen

    ///@detalis sendedCommand Text of command from the inputCommand.
    property string sendedCommand
    ///@detalis isCommandSended Sing of sending.
    property bool isCommandSended
    ///@detalis currentCommand Current text in consoleCmd.
    property alias currentCommand: consoleCmd.text
    ///@detalis consoleHistoryIndex Index for using KeyUp and KeyDown to the navigation in console history.
    property int consoleHistoryIndex
    ///@detalis consoleInput Reference to console input area
    property alias consoleInput: consoleCmd
    anchors
    {
        fill: parent
        topMargin: 24 * pt
        rightMargin: 44 * pt
        leftMargin: 24 * pt
        bottomMargin: 20 * pt

    }

    DapRectangleLitAndShaded
    {
        id: consoleRectangle
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        Item
        {
            anchors.fill: parent

            ListView
            {
                id: listViewConsoleCommand
    //            anchors.top: parent.top
    //            anchors.left: parent.left
    //            anchors.right: parent.right
                anchors.fill: parent
                anchors.bottomMargin: 50 * pt
                anchors.leftMargin: 20 *pt
                anchors.topMargin: 24 * pt
                height: (contentHeight < consoleRectangle.height - inputCommand.height) ?
                            contentHeight :
                            (consoleRectangle.height - inputCommand.height)
                clip: true
                model: modelConsoleCommand
                delegate: delegateConsoleCommand

                currentIndex: count - 1
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange

//                DapScrollViewHandling
//                {
//                    id: scrollHandler
//                    viewData: listViewConsoleCommand
//                    scrollMouseAtArrow: consoleScroll.mouseAtArrow
//                }
                ScrollBar.vertical: ScrollBar {
                    active: true
                }
            }

            //RowLayout
            Flickable
            {
                clip: true
                id: inputCommand
                width: parent.width
                //spacing: 0
                //anchors.left: parent.left
                //anchors.right: parent.right
                //anchors.top: listViewConsoleCommand.bottom
                anchors.bottom: parent.bottom
                //height: consoleCmd.contentHeight
                height: contentHeight < 100 * pt ? contentHeight : 100 * pt
                contentHeight: consoleCmd.height

                ScrollBar.vertical: ScrollBar {}

                Text
                {
//                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: promt
                    //verticalAlignment: Qt.AlignVCenter
                    text: ">"
                    color: currTheme.textColor
    //                Layout.left: parent.left
                    x: 20 * pt
                    y: 5 * pt

                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                }

                TextArea
                {
                    id: consoleCmd
                    //verticalAlignment: Qt.AlignVCenter
                    width: parent.width - x
                    //Layout.fillWidth: true
                    anchors.bottom: parent.bottom
                    x: promt.x + promt.width + 5 * pt
                    //                Layout.leftMargin: 10 * pt
                    wrapMode: TextArea.Wrap
                    placeholderText: qsTr("Type here...")
                    selectByMouse: true
                    color: currTheme.textColor
                    focus: true
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                    Keys.onReturnPressed: text.length > 0 ?
                                              sendedCommand = text :
                                              sendedCommand = ""
                    Keys.onEnterPressed: text.length > 0 ?
                                             sendedCommand = text :
                                             sendedCommand = ""
                    Keys.onUpPressed: (consoleHistoryIndex < dapConsoleRigthPanel.dapModelHistoryConsole.count - 1) ?
                                          consoleHistoryIndex += 1 :
                                          null
                    Keys.onDownPressed: (consoleHistoryIndex > -1) ?
                                            consoleHistoryIndex -= 1 :
                                            null

                    onLineCountChanged: inputCommand.contentY = inputCommand.contentHeight - inputCommand.height
                }
            }
        }
    }
}
