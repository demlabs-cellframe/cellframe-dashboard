import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

DapConsoleScreenForm
{
    ListModel
    {
        id: modelConsoleCommand
        ListElement
        {
            query: "Command"
            response: "This answer"
        }
    }

    Component
    {
        id: delegateConsoleCommand
        Column
        {
            Text
            {
                id: textQuery
                text: "> " + query
                font.pixelSize: 14 * pt
            }
            Text
            {
                id: textResponse
                text: response
                font.pixelSize: 14 * pt
            }
        }
    }
}
