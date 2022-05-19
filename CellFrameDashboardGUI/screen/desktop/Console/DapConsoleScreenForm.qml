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
                //width: commandCmdController.maxLengthText(model) * 15 * pt//200 * pt
                anchors.bottom: inputCommand.top
                x: 20 * pt

                onWordSelected: inputField.text = word

                /*onVisibleChanged:
                {
                    closeSuggestionBoxButton.visible = suggestionsBox.visible
                }*/
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
                    onClicked: suggestionsBox.model = {}
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
                        y: 2 * pt

                        font: mainFont.dapFont.regular18
                    }

                    /* Suggestions {
                        id: suggestions
                    }*/

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
                                suggestionsBox.model = commandCmdController.getTreeWords(text)
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



                    /*TextField
                    {
                        id: consoleCmd
                        width: parent.width - x
                        anchors.bottom: parent.bottom
                        x: promt.x + promt.width + 5 * pt
                        wrapMode: TextArea.Wrap
                        validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\(\)\?\s*]+/ }
                        placeholderText: qsTr("Type here...")
                        selectByMouse: true
                        background: Rectangle{color: currTheme.backgroundElements}

                        property int autocomleteStatus: 0
                        // 0 - самое начало ввода, 1 - нажат таб и автодополнение срабатывает,
                        // 2 - после 1 введен пробел и можно продолжить автодополнение параметрами
                        // (тут по нажатию таба будут по очереди перебираться варианты параметров, а по ентеру будет выбран нужный)

                        color: currTheme.textColor
                        focus: true
                        font: mainFont.dapFont.regular18

                        Keys.onRightPressed:
                        {
                            if (autocomleteStatus == 2 && consoleCmd.cursorPosition == consoleCmd.text.length && autocompleteText.text != "")
                            {
                                consoleCmd.text = autocompleteText.text
                                if (autocompleteText.text.length <= consoleCmd.text.length)
                                {
                                    autocomleteStatus = 0
                                }
                                autocompleteParamsCount = 0
                            }
                            else
                                if (consoleCmd.cursorPosition != consoleCmd.text.length)
                                    ++consoleCmd.cursorPosition
                        }

                        Keys.onReturnPressed:
                        {
                            text.length > 0 ?
                                 sendedCommand = text :
                                 sendedCommand = ""
                            autocompleteParamsCount = 0
                            autocomleteStatus = 0
                        }
                        Keys.onEnterPressed:
                        {
                            autocompleteText.text = ""
                            autocompleteParamsCount = 0
                            autocomleteStatus = 0
                            text.length > 0 ?
                                 sendedCommand = text :
                                 sendedCommand = ""
                        }
                        Keys.onUpPressed:
                        {
                            //console.log("cococount", autocomleteStatus, autocompleteParamsCount)

                                //{

                            (consoleHistoryIndex < dapConsoleRigthPanel.dapModelHistoryConsole.count - 1) ?
                            consoleHistoryIndex += 1 :
                            null
                                    if (!commandCmdController.isOneWord(consoleCmd.text))
                                    {
                                        autocomleteStatus = 2
                                        autocompleteParamsCount = 0
                                        autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                    }
                                    else
                                    {
                            autocompleteParamsCount = 0
                            autocomleteStatus = 0
                                    }
                                //}
                        }
                        Keys.onDownPressed:
                        {
                            /*if (autocomleteStatus == 2 && autocompleteText.text.length >= consoleCmd.text.length)
                            {
                                autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                --autocompleteParamsCount
                            }
                            else*/
                    //{
                    /* (consoleHistoryIndex > -1) ?
                            consoleHistoryIndex -= 1 :
                            null

                                if (!commandCmdController.isOneWord(consoleCmd.text))
                                {
                                    autocomleteStatus = 2
                                    autocompleteParamsCount = 0
                                    autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                }
                                else
                                {
                        autocompleteParamsCount = 0
                        autocomleteStatus = 0
                                }
                            //}
                        }

                        property int autocompleteParamsCount: 0

                        Keys.onTabPressed:
                        {
                            if (autocomleteStatus == 2 && autocompleteText.text.length >= consoleCmd.text.length)
                            {
                                autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                ++autocompleteParamsCount
                            }
                            else
                            if (autocomleteStatus == 0 && consoleCmd.text != "")
                            {
                                autocomleteStatus = 1
                                var str = commandCmdController.getCommandByValue(consoleCmd.text)
                                if (str != "")
                                {
                                    consoleCmd.text = str
                                    autocompleteText.text = consoleCmd.text
                                }
                            }
                        }

                        onTextChanged:
                        {
                            inputCommand.contentY = inputCommand.contentHeight - inputCommand.height

                            if (autocomleteStatus == 2)
                            {
                                autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                if (commandCmdController.isOneWord(consoleCmd.text))
                                    autocomleteStatus = 0
                            }
                            else
                                if (commandCmdController.isOneWord(consoleCmd.text) && autocomleteStatus == 1)
                                {
                                    autocompleteParamsCount = 0
                                    autocomleteStatus = 0
                                }

                            else
                            if (autocomleteStatus == 1 && text == autocompleteText.text + " ")
                            {
                                autocomleteStatus = 2
                                autocompleteParamsCount = 0
                                autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                            }
                            else
                            if (text != "" && autocomleteStatus == 0)
                            {
                                autocompleteText.text = commandCmdController.getCommandByValue(consoleCmd.text)
                                if (text[text.length - 1] == " ")
                                {
                                    autocomleteStatus = 2
                                    autocompleteParamsCount = 0
                                    autocompleteText.text = commandCmdController.getCommandParams(consoleCmd.text, autocompleteParamsCount)
                                }
                            }
                            else
                                autocompleteText.text = ""
                        }



                        Text
                        {
                            id: autocompleteText
                            width: parent.width - x * 1.7
                            height: parent.height
                            x: 10 * pt
                            y: 6 * pt
                            wrapMode: TextArea.Wrap
                            color: currTheme.textColor
                            font: mainFont.dapFont.regular18
                            opacity: 0.5

                        }

                    }*/


                }
            }
        }
    }



}
