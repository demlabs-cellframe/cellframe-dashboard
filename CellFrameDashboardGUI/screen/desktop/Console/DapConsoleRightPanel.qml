import QtQuick 2.4

DapConsoleRightPanelForm
{
    ListModel
    {
        id: modelHistoryConsole
        ListElement
        {
            query: "help"
        }
        ListElement
        {
            query: "wallet list"
        }
        ListElement
        {
            query: "help"
        }
        ListElement
        {
            query: "wallet list"
        }
    }
}
