import QtQuick 2.4
import QtQuick.Controls 2.0
import Qt.labs.platform 1.0

import "../../"
import "qrc:/widgets" as Widgets
import "../controls" as Controls

Controls.DapTopPanel
{
    id:topLogsPanel

    //Export failure logs button
    Widgets.DapButton
    {
        id: exportLogButton
        textButton: qsTr("Export failure logs")
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 36
        implicitWidth: 164
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter

        onClicked: exportPopup.open()

        Widgets.DapCustomToolTip{
            contentText: qsTr("Export failure logs to file")
        }
    }

//    ///Handler for clicking the button exportLogButton
//    Connections
//    {
//        target: exportLogButton
//        function onClicked()
//        {
//            grub();
//            exportLogButton.colorBackgroundNormal = "#D2145D"
//            saveWindow.sourceComponent = saveFile;
//        }
//    }


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
            title: qsTr("Save the file")
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
                logicMainApp.requestToService("DapExportLogCommand",resultAddres,sendLogToFile());

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

    ///Creating a screenshot of a window
    function grub()
    {
        var x = mainWindow.grabToImage(function(result){screenShotMainWindow.source = result.url;},
                                       Qt.size(mainWindow.width, mainWindow.height));
        fastBlurMainWindow.source = screenShotMainWindow
        fastBlurMainWindow.visible = true
    }

    ///Default window settings
    function setPropertyDefaultWindow()
    {
        fastBlurMainWindow.visible = false;
        saveWindow.sourceComponent = undefined;
    }
}
