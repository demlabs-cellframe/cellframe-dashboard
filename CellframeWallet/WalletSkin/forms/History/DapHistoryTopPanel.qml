import QtQuick 2.4
import "qrc:/widgets"

DapSelector {

    signal selected(var status)

    selectorModel: selectorModel
    selectorListView.interactive: false
    textFont: mainFont.dapFont.medium12

    border.color: currTheme.secondaryBackground

    ListModel {
        id: selectorModel
        ListElement {
            name: qsTr("All statuses")
            tag: "All statuses"
        }
        ListElement {
            name: qsTr("Pending")
            tag: "Pending"
        }
        ListElement {
            name: qsTr("Sent")
            tag: "Sent"
        }
        ListElement {
            name: qsTr("Received")
            tag: "Received"
        }
        ListElement {
            name: qsTr("Error")
            tag: "Error"
        }
    }

    onItemSelected:
    {
        selected(selectorModel.get(currentIndex).tag)
    }
}
