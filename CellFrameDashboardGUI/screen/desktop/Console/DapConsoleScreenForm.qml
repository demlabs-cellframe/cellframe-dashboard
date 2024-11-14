import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../../"
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
    property alias consoleInput: inputField
    property alias dapInputCommand: inputCommand
    property alias listView: listViewConsoleCommand

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    DapRectangleLitAndShaded
    {
        id: consoleRectangle
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
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
                anchors.bottomMargin: 40 *pt

                anchors.leftMargin: 16 *pt
                anchors.rightMargin: 16 *pt

                anchors.topMargin: 16 *pt
                height: (contentHeight < consoleRectangle.height - inputCommand.height) ?
                            contentHeight :
                            (consoleRectangle.height - inputCommand.height)
                clip: true
                model: modelConsoleCommand
                delegate: delegateConsoleCommand
                cacheBuffer: 10000

                spacing: 0

                currentIndex: count - 1
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.ApplyRange

                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                onModelChanged:
                {
                    positionViewAtEnd()
                }
                Component.onCompleted: positionViewAtEnd()
            }

            SuggestionBox
            {
                id: suggestionsBox
                anchors.bottom: inputCommand.top

                x: 20
                z: 4

                onWordSelected: {
                console.log("the text")
                var cursorPos = inputField.textInput.cursorPosition
                var spaceBefore = inputField.text.lastIndexOf(" ", cursorPos - 1);

                if (spaceBefore === -1) {
                    spaceBefore = 0;
                } else {
                    spaceBefore += 1;
                }
                inputField.text = inputField.text.substring(0, spaceBefore) + word + " "
                }
            }

            InnerShadow {
                anchors.fill: suggestionsBox
                horizontalOffset: 1
                verticalOffset: 1
                samples: 4
                cached: true
                opacity: 1.0
                color: currTheme.reflection
                source: suggestionsBox
                visible: suggestionsBox.visible
                z: 4 + 100
            }

            DropShadow {
                    anchors.fill: suggestionsBox
                    horizontalOffset: 6
                    verticalOffset: 6
                    radius: 8.0
                    samples: 17
                    opacity: 0.7
                    color: "#80000000"
                    source: suggestionsBox
                    visible: suggestionsBox.visible
                    z: 4
                }

            Item
            {
                id: closeSuggestionBoxButton
                width: 15 
                height: width

                x: suggestionsBox.x + suggestionsBox.width
                y: suggestionsBox.y - height

                visible: suggestionsBox.visible

                Text
                {
                    anchors.centerIn: parent
                    text: "×"
                    font.pointSize: 16
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
//                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: contentHeight < 100  ? contentHeight : 100 
                contentHeight: consoleCmd.height

                ScrollBar.vertical: ScrollBar {}

                Rectangle
                {
                    color: currTheme.secondaryBackground
                    anchors.fill: parent

                    Text
                    {
                        Layout.fillHeight: true
                        id: promt
                        text: ">"
                        color: currTheme.white
                        x: 20 
                        y: 1 

                        font: mainFont.dapFont.regular18
                    }

                    Item {
                        id: consoleCmd
                        width: parent.width - x
                        height: 40
                        anchors.bottom: parent.bottom
                        x: promt.x + promt.width + 5 

                        FontMetrics {
                            id: metrics
                            font: suggestionsBox.itemFont
                        }

                        LineEdit {
                            id: inputField
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 30

                            Connections{
                                target: commandHelperController

                                function onHelpListGeted(list)
                                {
                                    findMaxLenIndex(list)
                                    suggestionsBox.model = list
                                }

                                function findMaxLenIndex(lst)
                                {
                                    var resultIndex = 0
                                    var maxLen = 0
                                    var maxWidth = 0
                                    var maxStr;

                                    for(var i = 0; i < lst.length; i++)
                                    {
                                        var tmpStr = lst[i]
                                        if(maxLen <= tmpStr.length)
                                        {
                                            var tmpWidth = getStrWidth(tmpStr)
                                            if(maxWidth < tmpWidth) {
                                                maxLen = tmpStr.length
                                                maxWidth = tmpWidth
                                                maxStr = tmpStr
                                                resultIndex = i
                                            }
                                        }
                                    }

                                    suggestionsBox.maxLenIndex = resultIndex
                                    suggestionsBox.itemWidth = maxWidth;
                                }
                                
                                function getStrWidth(str) {
                                    var limit = 500
                                    var width = metrics.boundingRect(str).width
                                    return limit < width ? limit : width
                                }
                            }

                            onSugTextChanged:
                            {
                                commandHelperController.tryListGetting(text, inputField.textInput.cursorPosition)
                            }

                            onEnterPressed:
                            {
                                if (!suggestionsBox.visible)
                                {
                                    var str = textInput.text.trim()
                                    str.length > 0 ?
                                                sendedCommand = str :
                                                sendedCommand = ""
                                    textInput.text = ""
                                }

                                else
                                {

                                    var cursorPos = inputField.textInput.cursorPosition
                                    var spaceBefore = text.lastIndexOf(" ", cursorPos - 1);
                                    var spaceAfter = text.indexOf(" ", cursorPos);
                                    if (spaceBefore === -1) {
                                        spaceBefore = 0;
                                    } else {
                                        spaceBefore += 1;
                                    }
                                    if (spaceAfter === -1) {
                                        spaceAfter = text.length;
                                    }

                                    inputField.text = text.substring(0, spaceBefore) + suggestionsBox.model[suggestionsBox.selectedIndex] + " "
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
                            Keys.onEscapePressed: suggestionsBox.model = {}
                        }
                    }
                }
            }
        }
    }
}
