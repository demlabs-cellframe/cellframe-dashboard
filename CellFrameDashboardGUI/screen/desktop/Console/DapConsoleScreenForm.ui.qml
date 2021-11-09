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
        top: parent.top
        topMargin: 24 * pt
        right: parent.right
        rightMargin: 20 * pt
        left: parent.left
        leftMargin: 24 * pt
        bottom: parent.bottom
        bottomMargin: 20 * pt

    }

    Rectangle
    {
        id: consoleRectangle
        anchors.fill: parent
//        anchors.bottomMargin: 20 * pt
//        anchors.topMargin: 24 * pt
//        anchors.leftMargin: 120 * pt
//        anchors.rightMargin: 20 * pt
//        anchors.bottomMargin: 20 * pt
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle

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
                color: currTheme.textColor
                anchors.left: parent.left
                anchors.leftMargin: 20 * pt

                font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
            }

            TextArea
            {
                id: consoleCmd
                Layout.fillWidth: true
                Layout.leftMargin: 20 * pt
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
            }
        }
    }

    DapScrollView
    {
        id: consoleScroll
        scrollDownButtonImageSource: "qrc:/resources/icons/ic_scroll-down.png"
        scrollDownButtonHoveredImageSource: "qrc:/resources/icons/ic_scroll-down_hover.png"
        scrollUpButtonImageSource: "qrc:/resources/icons/ic_scroll-up.png"
        scrollUpButtonHoveredImageSource: "qrc:/resources/icons/ic_scroll-up_hover.png"
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
    InnerShadow {
        id: topLeftSadow
        anchors.fill: consoleRectangle
        cached: true
        horizontalOffset: 5
        verticalOffset: 5
        radius: 4
        samples: 32
        color: "#2A2C33"
        smooth: true
        source: consoleRectangle
        visible: consoleRectangle.visible
    }
    InnerShadow {
        anchors.fill: consoleRectangle
        cached: true
        horizontalOffset: -1
        verticalOffset: -1
        radius: 1
        samples: 32
        color: "#4C4B5A"
        source: topLeftSadow
        visible: consoleRectangle.visible
    }
}
