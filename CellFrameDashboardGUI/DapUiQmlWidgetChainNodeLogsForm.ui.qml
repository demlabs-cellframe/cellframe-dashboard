import QtQuick 2.0
import QtQuick.Controls 2.0

Page {
    id: dapUiQmlWidgetChainNodeLogs
    title: "Logs"

    property alias listViewLogs: listViewLogs

    Connections {
        target: dapServiceController
        onLogCompleted:
        {
            listViewLogs.model = null
            listViewLogs.model = dapLogModel
        }
    }

    Rectangle
    {
        id: rectangleBackgroundPageLogs
        anchors.fill: parent
        color: "#36314D"

        ListView
        {
            id: listViewLogs
            anchors.fill: parent
            focus: true
            model: dapLogModel
            spacing: 3
            anchors.margins: 3

            delegate: componentItenDelegate
        }
    }

}
