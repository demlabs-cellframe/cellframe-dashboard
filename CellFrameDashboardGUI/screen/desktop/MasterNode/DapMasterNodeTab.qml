import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "qrc:/widgets"
import "RightPanel"

DapPage {

    readonly property string startMasterNodePanel:  path + "/MasterNode/RightPanel/DapStartMasterNodeRightPanel.qml"
    readonly property string loaderMasterNodePanel:  path + "/MasterNode/RightPanel/DapLoaderMasterNodeRightPanel.qml"
    readonly property string ordersMasterNodePanel:  path + "/MasterNode/RightPanel/DapOrdersMasterNodeRightPanel.qml"
    readonly property string createMasterNodeDone: path + "/MasterNode/RightPanel/DapCreateMasterNodeDone.qml"
    readonly property string lastActionsMasterNode: path + "/MasterNode/RightPanel/DapLastActionsMasterNode.qml"
    readonly property string baseMasterNodePanel: path + "/MasterNode/RightPanel/DapBaseMasterNodeRightPanel.qml"
    readonly property string orderCreateMasterNodePanel: path + "/MasterNode/RightPanel/DapCreateOrderMasterNode.qml"

    property var registrationStagesText: [
        qsTr("Checking public key"),
        qsTr("Updating configs"),
        qsTr("Restarting node"),
        qsTr("Creating order"),
        qsTr("Adding node data in network and checking added data"),
        qsTr("Creating order"),
        qsTr("Checking stake result"),
        qsTr("Sending stake hash for verify"),
        qsTr("Checking all data")
    ]

    Component{id: emptyRightPanel; Item{}}


    dapHeader.initialItem: DapSearchTopPanel{

        isVisibleSearch: false
    }

    dapScreen.initialItem:
        DapMasterNodeScreen
        {

        }

    dapRightPanelFrame.visible: true
    //dapRightPanel.initialItem: emptyRightPanel
    dapRightPanel.initialItem:
        DapCreateMasterNodeDone
    {

    }

    Component.onCompleted:
    {
        if(nodeMasterModule.isSandingDataStage)
        {
            dapRightPanel.push(createMasterNodeDone)
        }
        else
        {
            dapRightPanel.push(baseMasterNodePanel)
        }
    }

    Component.onDestruction:
    {

    }

    Connections
    {
        target: nodeMasterModule

        function onRegistrationNodeStarted()
        {
            dapRightPanel.push(loaderMasterNodePanel)
        }

        function onCreationStageChanged()
        {
            if(nodeMasterModule.isSandingDataStage)
            {
                dapRightPanel.push(createMasterNodeDone)
            }
        }

        function onCertMovedSignal(numberMessage)
        {
            if(numberMessage === 1)
            {
                dapMainWindow.infoItem.showInfo(
                            120,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Success"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
            else
            {
                dapMainWindow.infoItem.showInfo(
                            160,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Not a success"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
            }
        }

        function onWalletMovedSignal(numberMessage)
        {
            if(numberMessage === 1)
            {
                dapMainWindow.infoItem.showInfo(
                            120,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Success"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/check_icon.png")
            }
            else
            {
                dapMainWindow.infoItem.showInfo(
                            160,0,
                            dapMainWindow.width*0.5,
                            8,
                            qsTr("Not a success"),
                            "qrc:/Resources/" + pathTheme + "/icons/other/no_icon.png")
            }
        }
    }

}
