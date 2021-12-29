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

        dapDownloadPanel.reloadButton.onClicked:
        {

        }

        dapDownloadPanel.canceledButton.onClicked:
        {
            pluginsManager.cancelDownload();
        }
    }

    dapRightPanel: Item{}

    Connections{
        target: dapMainWindow
        onModelPluginsUpdated:
        {
            updateFiltrApps(dAppsScreen.currentFiltr)
        }
    }

    Connections{
        target:pluginsManager
        onRcvProgressDownload:
        {
            if(!completed)
            {
                if(!dAppsScreen.dapDownloadPanel.isOpen)
                {
                    dAppsScreen.dapDefaultRightPanel.visible = false
                    dAppsScreen.dapDownloadPanel.visible = true
                    dAppsScreen.dapDownloadPanel.isOpen = true
                    dAppsScreen.dapDownloadPanel.progress_text.text = progress + " %";
                    dAppsScreen.dapDownloadPanel.progress_bar.currentValue = progress;
                    dAppsScreen.dapDownloadPanel.name = name;
                    dAppsScreen.dapDownloadPanel.download =  download;
                    dAppsScreen.dapDownloadPanel.total =  total;
                    dAppsScreen.dapDownloadPanel.time = time;
                    dAppsScreen.dapDownloadPanel.speed = speed;
                    dAppsScreen.dapDownloadPanel.errors.text = error;

                }
                else
                {
                    dAppsScreen.dapDownloadPanel.progress_text.text = progress + " %";
                    dAppsScreen.dapDownloadPanel.progress_bar.currentValue = progress;
                    dAppsScreen.dapDownloadPanel.name = name;
                    dAppsScreen.dapDownloadPanel.download = download;
                    dAppsScreen.dapDownloadPanel.total = total;
                    dAppsScreen.dapDownloadPanel.time = time;
                    dAppsScreen.dapDownloadPanel.speed = speed;
                    dAppsScreen.dapDownloadPanel.errors.text = error;
                }
                if(error === "Connected")
                {
                    dAppsScreen.dapDownloadPanel.errors.color = currTheme.placeHolderTextColor
                }
                else
                {
                     dAppsScreen.dapDownloadPanel.errors.color = currTheme.buttonColorNormal
                }
            }
            else
            {
                dAppsScreen.dapDownloadPanel.visible = false;
                dAppsScreen.dapDownloadPanel.progress_text.text = "";
                dAppsScreen.dapDefaultRightPanel.visible = true;
            }
        }
        onRcvAbort:
        {
            dAppsScreen.dapDownloadPanel.visible = false
            dAppsScreen.dapDownloadPanel.isOpen = false
            dAppsScreen.dapDownloadPanel.progress_text.text = "";
            dAppsScreen.dapDefaultRightPanel.visible = true;
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
