import QtQuick 2.12
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "qrc:/walletSkin/"
import "../../"
import "../controls"
import "logic"

Page {

    title: qsTr("dApps")
    background: Rectangle {color: currTheme.mainBackground }
    hoverEnabled: true

    property alias dapAppsModel: listModelApps
//    property alias dapAppsScreen: dAppsScreen

    id: dapAppsTab
    signal updateButtons();

    AppsLogic{id: dAppsLogic}

    ListModel{id: listModelApps}
    ListModel{id: temporaryModel}




    DapAppsScreen{
        id: dAppsScreen
        onUpdateFiltr: dAppsLogic.updateFiltrApps(status);

//        dapDownloadPanel.reloadButton.onClicked:
//        {
//            pluginsManager.reloadDownload();
//        }

//        dapDownloadPanel.canceledButton.onClicked:
//        {
//            pluginsManager.cancelDownload();
//        }
//        dapDownloadPanel.closeButton.onClicked:
//        {
//            pluginsManager.cancelDownload();
//        }
    }

    Connections{
        target: dapMainWindow
        function onModelPluginsUpdated()
        {
            dAppsLogic.updateFiltrApps(dAppsScreen.currentFiltr)
        }
    }

    Connections{
        target: pluginsController
        function onRcvProgressDownload(completed, error, progress, name, download, total, time, speed)
        {
//            dAppsLogic.rcvProgressDownload(completed, error, progress, name, download, total, time, speed)
        }
        function onRcvAbort()
        {
//            dAppsLogic.rcvAbort()
        }
    }

    Component.onCompleted:{
        pluginsController.updatePluginsRepository()
        dAppsLogic.updateFiltrApps(dAppsScreen.currentFiltr)
    }
}
