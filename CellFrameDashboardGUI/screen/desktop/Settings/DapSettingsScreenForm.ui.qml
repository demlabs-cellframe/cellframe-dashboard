import QtQuick 2.4
import QtQuick.Controls 2.0
import "../../"

DapAbstractScreen
{
    ///@detalis Listview to display settings items.
    property alias dapListViewSettings: listViewSettings
    ListView
    {
        id: listViewSettings
        anchors.fill: parent
        model: modelSettings
    }
}
