import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
//import CommandCmdController 1.0
import "qrc:/"
import "Suggestion"

Page
{
    id: consoleScreen

    ///@detalis sendedCommand Text of command from the inputCommand.
    property string sendedCommand
    ///@detalis isCommandSended Sing of sending.
    property bool isCommandSended
    ///@detalis currentCommand Current text in consoleCmd.
    property alias currentCommand: inputField.text
    ///@detalis consoleHistoryIndex Index for using KeyUp and KeyDown to the navigation in console history.
    property int consoleHistoryIndex
    ///@detalis consoleInput Reference to console input area
    property alias consoleInput: consoleCmd
    property alias dapInputCommand: inputCommand
    property alias listView: listViewConsoleCommand

    background: Rectangle
    {
        color: currTheme.backgroundMainScreen
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
                cacheBuffer: 5000

                currentIndex: count - 1
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange

                ScrollBar.vertical: ScrollBar {
                    active: true
                }
            }

            SuggestionBox
            {
                id: suggestionsBox
                anchors.bottom: inputCommand.top
                x: 20 * pt
                z: 4

                onWordSelected: inputField.text = word

                Rectangle
                {
                    width: parent.width
                    height: 1 * pt
                    color: currTheme.borderColor
                }

                Rectangle
                {
                    width: 1 * pt
                    height: parent.height
                    color: currTheme.borderColor
                }
            }

            DropShadow {
                    anchors.fill: suggestionsBox
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: suggestionsBox
                    visible: suggestionsBox.visible
                    z: 4
                }

            Item
            {
                id: closeSuggestionBoxButton
                width: 15 * pt
                height: width

                x: suggestionsBox.x + suggestionsBox.width
                y: suggestionsBox.y - height

                visible: suggestionsBox.visible

                Text
                {
                    anchors.centerIn: parent
                    text: "×"
                    font.pointSize: 20
                    color: "white"
                    font.bold: true
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        suggestionsBox.model = {}
                        commandCmdController.endCertsList()
                    }
                }
            }

            //RowLayout
            Flickable
            {
                clip: true
                id: inputCommand
                width: parent.width
                anchors.bottom: parent.bottom
                height: contentHeight < 100 * pt ? contentHeight : 100 * pt
                contentHeight: consoleCmd.height

                ScrollBar.vertical: ScrollBar {}

                Rectangle
                {
                    color: currTheme.backgroundElements
                    anchors.fill: parent

                    Text
                    {
                        Layout.fillHeight: true
                        id: promt
                        text: ">"
                        color: currTheme.textColor
                        x: 20 * pt
                        y: 1 * pt

                        font: mainFont.dapFont.regular18
                    }

                    Item {
                        id: consoleCmd
                        width: parent.width - x
                        height: 40 * pt
                        anchors.bottom: parent.bottom
                        x: promt.x + promt.width + 5 * pt

                        LineEdit {
                            id: inputField
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 30 * pt

                            onSugTextChanged:
                            {
                                suggestionsBox.model = commandCmdController.getWords(text)
                            }

                            onEnterPressed:
                            {
                                if (!suggestionsBox.visible)
                                {
                                    textInput.text.length > 0 ?
                                                sendedCommand = textInput.text :
                                                sendedCommand = ""
                                    textInput.text = ""
                                }

                                else
                                {
                                    inputField.text = suggestionsBox.model[suggestionsBox.selectedIndex].str
                                    suggestionsBox.selectedIndex = 0
                                }
                            }

                            onUpButtonPressed:
                            {
                                if (!suggestionsBox.visible)
                                {
                                    if (consoleHistoryIndex < dapConsoleRigthPanel.dapModelHistoryConsole.count - 1)
                                    {
                                        consoleHistoryIndex += 1
                                    }
                                }

                                else
                                {
                                    if (suggestionsBox.selectedIndex > 0)
                                        --suggestionsBox.selectedIndex
                                    else suggestionsBox.selectedIndex = suggestionsBox.model.length - 1
                                }
                            }

                            onDownButtonPressed:
                            {
                                if (!suggestionsBox.visible)
                                {
                                    (consoleHistoryIndex > -1) ?
                                                consoleHistoryIndex -= 1 :
                                                null
                                }
                                else
                                {
                                    if (suggestionsBox.selectedIndex < suggestionsBox.model.length - 1)
                                        ++suggestionsBox.selectedIndex
                                    else suggestionsBox.selectedIndex = 0
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
