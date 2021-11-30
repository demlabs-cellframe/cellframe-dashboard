import QtQuick 2.0

Component
{
    id: delegateConsoleCommand
    Column
    {
        width: parent.width
//            Layout.bottomMargin: 20 * pt
        Text
        {
            id: textQuery
            text: "> " + query
            font.family: "Quicksand"
            font.pixelSize: 18
            color: "#ffffff"

        }
        Text
        {
            id: textResponse
            text: response
            width: parent.width
            wrapMode: Text.Wrap
            font.family: "Quicksand"
            font.pixelSize: 18
            color: "#ffffff"
        }
    }
}
