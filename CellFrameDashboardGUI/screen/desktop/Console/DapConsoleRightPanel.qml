import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../"

Page
{
    property alias dapModelHistoryConsole: modelHistoryConsole
    ///@detalis commandQuery Command for history.
    property string commandQuery
    ///@detalis historyQuery Text of command from the command history.
    property string historyQuery
    ///@detalis historyQueryIndex Index of command from the command history.
    property string historyQueryIndex
    ///@detalis historySize Num of history command at right panel.
    property int historySize: 10

    ListModel
    {
        id: modelHistoryConsole
    }

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 * pt

            Text
            {
                id: textHeader
                anchors.fill: parent
                anchors.leftMargin: 24 * pt
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ListView
        {
            id: listViewHistoryConsole
            Layout.fillWidth: true
            Layout.fillHeight: true
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
    }




    Component.onCompleted:
    {
        dapServiceController.requestToService("DapGetHistoryExecutedCmdCommand", historySize);
    }

    //Returns true if item 'someElement' is already exist at list 'someModel'.
    function findElement(someModel, someElement)
    {
        for(var i = 0; i < someModel.count; ++i)
            if(someModel.get(i).query === someElement.query)
            {
                modelHistoryConsole.remove(i);
                return true;
            }

        return false;
    }

    onCommandQueryChanged:
    {
        //Adding only new element
        if(!findElement(modelHistoryConsole, {query: commandQuery}))
        {
            if(commandQuery !== "")
                modelHistoryConsole.insert(0, {query: commandQuery});
        }
        else
            modelHistoryConsole.insert(0, {query: commandQuery});

        //History is limited by historySize and realized as FIFO
        if(historySize < modelHistoryConsole.count)
            modelHistoryConsole.remove(modelHistoryConsole.count-1);
    }

    //Handler for the doubleClick on right history panel
    onHistoryQueryIndexChanged:
    {
        if(historyQueryIndex > -1)
        {
            historyQuery = modelHistoryConsole.get(historyQueryIndex).query;
            historyQueryIndex = -1;
            historyQuery = ""
        }
    }
}
