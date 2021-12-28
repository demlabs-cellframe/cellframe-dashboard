import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab {

    property alias dapAppsModel:listModelApps

    id: dapAppsTab
    signal updateButtons();

    color: currTheme.backgroundMainScreen

    ListModel{
        id: listModelApps
    }

    dapTopPanel: DapAppsTopPanel{color: currTheme.backgroundPanel}

    dapScreen: DapAppsScreen{
        id: dAppsScreen
        onUpdateFiltr: updateFiltrApps(status);
    }

    dapRightPanel: Item{}

    Connections{
        target: dapMainWindow
        onModelPluginsUpdated:
        {
            updateFiltrApps(dAppsScreen.currentFiltr)
        }
    }

    Component.onCompleted:{
        updateFiltrApps(dAppsScreen.currentFiltr)
    }

    function updateFiltrApps(status)
    {
        listModelApps.clear();

        if(status === "Verified")
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
            {
                if(dapModelPlugins.get(i).verifed === "1")
                    listModelApps.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
            }
        }
        else if(status === "Unverified")
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
            {
                if(dapModelPlugins.get(i).verifed === "0")
                    listModelApps.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
            }
        }
        else
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
                listModelApps.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
        }
        updateButtons();
    }
}
