import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2

Page {
    id: dapUiQmlWidgetChainNodeLogs
    title: "Logs"
    
    TableView {
        id: tableViewLogs
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right


        TableViewColumn {
            id: columnDate
            role: "date"
            title: "Date"
        }
        TableViewColumn {
            id: columnTime
            role: "time"
            title: "Time"
        }
        TableViewColumn {
            id: columnFile
            role: "file"
            title: "File"
        }
        TableViewColumn {
            id: columnMessage
            role: "Message"
            title: "Message"
        }
    }
    
                
    
}
