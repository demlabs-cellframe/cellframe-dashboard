import QtQuick 2.4
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import QtGraphicalEffects 1.0
import "../../"

DapLogsTopPanelForm
{
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

                onFileChanged:
                {
                    setPropertyDefaultWindow();
                }

                onRejected:
                {
                    setPropertyDefaultWindow();
                }
                Component.onCompleted: visible = true;
            }
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
        buttonNormalColor = "#070023";
    }
}
