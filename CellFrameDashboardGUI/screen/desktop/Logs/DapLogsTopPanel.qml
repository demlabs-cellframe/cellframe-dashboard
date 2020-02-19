import QtQuick 2.4
import Qt.labs.platform 1.0
import "../../"

DapLogsTopPanelForm
{
    ///@detalis filterFileArray Array with filters for the file saving window.
    property var filterFileArray:["Text files (*.txt)", "Log files (*.log)"]

    ///Loader for the Save window.
    Loader
    {
        id:saveWindow
    }
    ///Component for the Save dialog box.
    Component
    {
        id:saveFile
            FileDialog
            {
                id: saveDialog
                title: "Save the file"
                fileMode: FileDialog.SaveFile
                nameFilters: filterFileArray
                selectedNameFilter.index: 0
                modality: Qt.WindowModal

                onFileChanged:
                {
                    setPropertyDefaultWindow();

                    var resultAddres = String(currentFile).replace(/file:\/\//,"");
                    resultAddres = resultAddres.replace(/\.([$A-Za-z0-9]{2,4})/,"");
                    resultAddres += "." + selectedNameFilter.extensions[0];
                    dapServiceController.requestToService("DapExportLogCommand",resultAddres,sendLogToFile());

                }
                onRejected:
                {
                    setPropertyDefaultWindow();
                }
                Component.onCompleted: visible = true;
            }
    }
    ///Creates a string from the model to save to a file.
    function sendLogToFile()
    {
        var logArray = "";
        var tmpDate = new Date();
        for(var ind = 0; ind<dapLogsModel.count;ind++)
        {
            tmpDate.setTime(dapLogsModel.get(ind).momentTime);
            var dd = tmpDate.getDate();
            if (dd < 10) dd = '0' + dd;

            var mm = tmpDate.getMonth() + 1;
            if (mm < 10) mm = '0' + mm;

            var yy = tmpDate.getFullYear() % 100;
            if (yy < 10) yy = '0' + yy;

            logArray+="[" + mm + "/" + dd + "/" + yy + "-" + dapLogsModel.get(ind).time +"] ";
            logArray+="["+dapLogsModel.get(ind).type+"] ";
            logArray+="["+dapLogsModel.get(ind).file+"] ";
            logArray+=dapLogsModel.get(ind).info +"\n";
        }
        return logArray;

    }

    ///Default window settings
    function setPropertyDefaultWindow()
    {
        fastBlurMainWindow.visible = false;
        saveWindow.sourceComponent = undefined;
        buttonNormalColor = "#070023";
    }
}
