import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "qrc:/widgets"

DapPage {

    readonly property string startMasterNodePanel:  path + "/MasterNode/RightPanel/DapStartMasterNodeRightPanel.qml"


    Component{id: emptyRightPanel; Item{}}


    dapHeader.initialItem: DapSearchTopPanel{

        isVisibleSearch: false
    }

    dapScreen.initialItem:
        DapMasterNodeScreen
        {

        }

    dapRightPanelFrame.visible: true
    dapRightPanel.initialItem: emptyRightPanel

    Component.onCompleted:
    {

    }

    Component.onDestruction:
    {

    }



}
