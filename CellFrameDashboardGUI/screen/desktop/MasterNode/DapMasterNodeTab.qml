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
    readonly property string createMasterNodeDone: path + "/MasterNode/RightPanel/DapCreateMasterNodeDone.qml"
    readonly property string lastActionsMasterNode: path + "/MasterNode/RightPanel/DapLastActionsMasterNode.qml"

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

    }

    Component.onDestruction:
    {

    }
}
