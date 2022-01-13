import QtQuick 2.0

Component
{
    id: delegateConsoleCommand
    Column
    {
        width: parent.width
        TextEdit
        {
            width: parent.width
            id: textQuery
            readOnly: true
            selectByMouse: true
            text: "> " + query
            wrapMode: TextEdit.Wrap
            font.family: "Quicksand"
            font.pixelSize: 18
            color: "#ffffff"

        }
        TextEdit
        {
            id: textResponse
            readOnly: true
            selectByMouse: true
            text: response
            width: parent.width
            wrapMode: TextEdit.Wrap
            font.family: "Quicksand"
            font.pixelSize: 18
            color: "#ffffff"
        }
    }
}
