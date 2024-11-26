import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12

QtObject
{
    property var commandResult:
    {
        "success": "",
        "message": ""
    }

    property string currentTabName: qsTr("VPN")
    property string currentTabTechName: "VPN"

    function initDetailsModel(selectedModel)
    {
        detailsModel.clear()
        detailsModel.append(selectedModel)
    }
}
