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
            name: qsTr("Both")
        }
        ListElement {
            name: qsTr("Verified")
        }
        ListElement {
            name: qsTr("Unverified")
        }
    }

    onItemSelected:
    {
        selected(selectorModel.get(currentIndex).name)
    }
}
