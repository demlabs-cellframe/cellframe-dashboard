import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "qrc:/screen/controls"

DapPage {

    property alias dapAppsModel:listModelApps
    readonly property var currentIndex: 10

    id: dapAppsTab
    signal updateButtons();

//    color: currTheme.backgroundMainScreen

    ListModel{
        id: listModelApps
    }

    ListModel{
        id: temporaryModel
    }

    dapHeader.initialItem: HeaderItem{
//        color: currTheme.backgroundPanel
        onFindHandler: dapAppsTab.searchElement(text)
    }
    dapScreen.initialItem: DapAppsScreen{
        id: dAppsScreen
        onUpdateFiltr: updateFiltrApps(status);

        dapDownloadPanel.reloadButton.onClicked:
        {
            pluginsManager.reloadDownload();
        }

        dapDownloadPanel.canceledButton.onClicked:
        {
            pluginsManager.cancelDownload();
        }
        dapDownloadPanel.closeButton.onClicked:
        {
            pluginsManager.cancelDownload();
        }
    }
    onRightPanel: false

//    dapRightPanel.initialItem: Item{}

    Connections{
        target: dapMainPage
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
    Connections
    {
        target: dapMainPage
        onUpdatePage:
        {
            pluginsManager.updatePluginsRepository()
            updateFiltrApps(dAppsScreen.currentFiltr)
        }
    }


    function updateFiltrApps(status)
    {
        temporaryModel.clear()

        if(status === "Verified")
        {
            for(var i = 0; i < _dapModelPlugins.count; i++ )
            {
                if(_dapModelPlugins.get(i).verifed === "1")
                    temporaryModel.append({name:_dapModelPlugins.get(i).name, urlPath: _dapModelPlugins.get(i).path, status:_dapModelPlugins.get(i).status, verifed:_dapModelPlugins.get(i).verifed})
            }
        }
        else if(status === "Unverified")
        {
            for(var i = 0; i < _dapModelPlugins.count; i++ )
            {
                if(_dapModelPlugins.get(i).verifed === "0")
                    temporaryModel.append({name:_dapModelPlugins.get(i).name, urlPath: _dapModelPlugins.get(i).path, status:_dapModelPlugins.get(i).status, verifed:_dapModelPlugins.get(i).verifed})
            }
        }
        else
        {
            for(var i = 0; i < _dapModelPlugins.count; i++ )
                temporaryModel.append({name:_dapModelPlugins.get(i).name, urlPath: _dapModelPlugins.get(i).path, status:_dapModelPlugins.get(i).status, verifed:_dapModelPlugins.get(i).verifed})
        }

        listModelApps.clear();

        for (var i = 0; i < temporaryModel.count; ++i)
            listModelApps.append(temporaryModel.get(i))

        updateButtons();
    }

    function searchElement(text)
    {
        listModelApps.clear()
        for(var i = 0; i < temporaryModel.count; i++)
        {
            if(temporaryModel.get(i).name.includes(text))
            {
                if(dAppsScreen.currentFiltr === "Both")
                {
                    listModelApps.append(temporaryModel.get(i))
                }
                else if(dAppsScreen.currentFiltr === "Verified" && temporaryModel.get(i).verifed === "1")
                {
                    listModelApps.append(temporaryModel.get(i))
                }
                else if(dAppsScreen.currentFiltr === "Unverified" && temporaryModel.get(i).verifed === "0")
                {
                    listModelApps.append(temporaryModel.get(i))
                }
            }
            else if(text === "")
            {
                listModelApps.append(temporaryModel.get(i))
            }
        }
    }
}
