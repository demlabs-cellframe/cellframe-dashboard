import QtQuick 2.4

DapConsoleRightPanelForm
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
