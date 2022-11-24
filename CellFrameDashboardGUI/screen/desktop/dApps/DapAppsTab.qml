import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "logic"

DapPage {

    property alias dapAppsModel: listModelApps
//    property alias dapAppsScreen: dAppsScreen

    id: dapAppsTab
    signal updateButtons();

    AppsLogic{id: dAppsLogic}

    ListModel{id: listModelApps}

    ListModel{id: temporaryModel}

    dapHeader.initialItem: DapSearchTopPanel{
        onFindHandler: dAppsLogic.searchElement(text)
    }

    dapScreen.initialItem: DapAppsScreen{
        id: dAppsScreen
        onUpdateFiltr: dAppsLogic.updateFiltrApps(status);

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

    Connections{
        target: dapMainWindow
        function onModelPluginsUpdated()
        {
            dAppsLogic.updateFiltrApps(dAppsScreen.currentFiltr)
        }
    }

    Connections{
        target:pluginsManager
        function onRcvProgressDownload(completed, error, progress, name, download, total, time, speed)
        {
            dAppsLogic.rcvProgressDownload(completed, error, progress, name, download, total, time, speed)
        }
        function onRcvAbort()
        {
            dAppsLogic.rcvAbort()
        }
    }

    Component.onCompleted:{
        pluginsManager.updatePluginsRepository()
        dAppsLogic.updateFiltrApps(dAppsScreen.currentFiltr)
    }
}
