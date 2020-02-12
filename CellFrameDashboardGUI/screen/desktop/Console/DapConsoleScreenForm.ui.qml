import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
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

    Rectangle
    {
        id: consoleRectangle
        anchors.fill: parent
        anchors.topMargin: 24 * pt
        anchors.leftMargin: 20 * pt
        anchors.rightMargin: 20 * pt
        anchors.bottomMargin: 20 * pt

        ListView
        {
            id: listViewConsoleCommand
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: (contentHeight < consoleRectangle.height - inputCommand.height) ?
                        contentHeight :
                        (consoleRectangle.height - inputCommand.height)
            clip: true
            model: modelConsoleCommand
            delegate: delegateConsoleCommand
            currentIndex: count - 1
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.ApplyRange

            DapScrollViewHandling
            {
                id: scrollHandler
                viewData: listViewConsoleCommand
                scrollMouseAtArrow: consoleScroll.mouseAtArrow
            }
        }

        RowLayout
        {
            id: inputCommand
            spacing: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: listViewConsoleCommand.bottom
            height: consoleCmd.contentHeight

            Text
            {
                id: promt
                verticalAlignment: Qt.AlignVCenter
                text: ">"
                color: "#070023"
                font: themeConsole.inputCommandFont
            }

            TextArea
            {
                id: consoleCmd
                Layout.fillWidth: true
                wrapMode: TextArea.Wrap
                placeholderText: qsTr("Type here...")
                selectByMouse: true
                focus: true
                font: themeConsole.inputCommandFont
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
            }
        }
    }

    DapScrollView
    {
        id: consoleScroll
        scrollDownButtonImageSource: "qrc:/res/icons/ic_scroll-down.png"
        scrollDownButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-down_hover.png"
        scrollUpButtonImageSource: "qrc:/res/icons/ic_scroll-up.png"
        scrollUpButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-up_hover.png"
        viewData: listViewConsoleCommand
        //Assign DapScrollView with DapScrollViewHandling which must have no parent-child relationship
        onClicked: scrollHandler.scrollDirectionUp = !scrollHandler.scrollDirectionUp
        scrollButtonVisible: scrollHandler.scrollVisible
        scrollButtonArrowUp: scrollHandler.scrollDirectionUp
        scrollButtonTopMargin: 10 * pt
        scrollButtonBottomMargin: 10 * pt
        scrollButtonLeftMargin: 10 * pt
        scrollButtonRightMargin: 10 * pt
    }
}
