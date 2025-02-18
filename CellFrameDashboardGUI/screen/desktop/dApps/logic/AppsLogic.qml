import QtQuick 2.12
import QtQml 2.12

QtObject {


    function rcvProgressDownload(completed, error, progress, name, download, total, time, speed)
    {
        if(!completed)
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
            if(error === "Connected")
            {
                 dAppsScreen.dapDownloadPanel.errors.color = currTheme.lightGreen
            }
            else
            {
                 dAppsScreen.dapDownloadPanel.errors.color = currTheme.red
            }
        }
        else
        {
            dAppsScreen.dapDownloadPanel.visible = false;
            dAppsScreen.dapDownloadPanel.progress_text.text = "";
            dAppsScreen.dapDefaultRightPanel.visible = true;
        }
    }

    function rcvAbort()
    {
        dAppsScreen.dapDownloadPanel.visible = false
        dAppsScreen.dapDownloadPanel.isOpen = false
        dAppsScreen.dapDownloadPanel.progress_text.text = "";
        dAppsScreen.dapDefaultRightPanel.visible = true;
    }

    function updateFiltrApps(status)
    {
        temporaryModel.clear()

        if(status === "Verified")
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
            {
                if(dapModelPlugins.get(i).verifed === "1")
                    temporaryModel.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
            }
        }
        else if(status === "Unverified")
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
            {
                if(dapModelPlugins.get(i).verifed === "0")
                    temporaryModel.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
            }
        }
        else
        {
            for(var i = 0; i < dapModelPlugins.count; i++ )
                temporaryModel.append({name:dapModelPlugins.get(i).name, urlPath: dapModelPlugins.get(i).path, status:dapModelPlugins.get(i).status, verifed:dapModelPlugins.get(i).verifed})
        }

        listModelApps.clear();

        for (var i = 0; i < temporaryModel.count; ++i)
            listModelApps.append(temporaryModel.get(i))

        updateButtons();
    }

    function searchElement(text)
    {
        var fstr = text.toLocaleLowerCase()

        listModelApps.clear()
        for(var i = 0; i < temporaryModel.count; i++)
        {
            var name = temporaryModel.get(i).name
            if(name.toLowerCase().indexOf(fstr) >= 0)
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
