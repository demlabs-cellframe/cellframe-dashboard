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

            RowLayout
            {
                id: inputCommand
                spacing: 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: listViewConsoleCommand.bottom
                height: 50


                Text
                {
//                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: promt
                    verticalAlignment: Qt.AlignVCenter
                    text: ">"
                    color: currTheme.textColor
    //                Layout.left: parent.left
                    Layout.leftMargin: 20 * pt

                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                }

                Flickable {
                    id:flick
                    Layout.fillWidth: true
                    Layout.fillHeight: true
//                    height: contentHeight
//                    contentWidth: width
//                    contentHeight: consoleCmd.implicitHeight

                    clip: true

                    ScrollBar.vertical: ScrollBar {}

//                    flickableDirection: Flickable.VerticalFlick

                    TextArea.flickable: TextArea {
                        id: consoleCmd

                        verticalAlignment: Qt.AlignVCenter

                        wrapMode: TextArea.Wrap
                        placeholderText: qsTr("Type here...")
                        selectByMouse: true
                        color: currTheme.textColor
                        focus: true
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
                        clip: true
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

//                        onTextChanged: { consoleCmd.cursorPosition = consoleCmd.length }
                    }
                }




//                TextArea
//                {
//                    id: consoleCmd
//                    verticalAlignment: Qt.AlignVCenter
//                    Layout.fillWidth: true
//    //                Layout.leftMargin: 10 * pt
//                    wrapMode: TextArea.Wrap
//                    placeholderText: qsTr("Type here...")
//                    selectByMouse: true
//                    color: currTheme.textColor
//                    focus: true
//                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular18
//                    clip: true
//                    Keys.onReturnPressed: text.length > 0 ?
//                                              sendedCommand = text :
//                                              sendedCommand = ""
//                    Keys.onEnterPressed: text.length > 0 ?
//                                             sendedCommand = text :
//                                             sendedCommand = ""
//                    Keys.onUpPressed: (consoleHistoryIndex < dapConsoleRigthPanel.dapModelHistoryConsole.count - 1) ?
//                                          consoleHistoryIndex += 1 :
//                                          null
//                    Keys.onDownPressed: (consoleHistoryIndex > -1) ?
//                                            consoleHistoryIndex -= 1 :
//                                            null

//                }
            }
        }
    }
}
