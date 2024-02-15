import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "qrc:/widgets"

DapPage {

    readonly property string createNewOrder:  path + "/Orders/RightPanel/DapMasterNodeOrdes.qml"


    Component{id: emptyRightPanel; Item{}}


    dapHeader.initialItem: DapSearchTopPanel{

        isVisibleSearch: false
    }

    dapScreen.initialItem:
        DapMasterNodeScreen
        {
            id: dashboardScreen
        }

    dapRightPanelFrame.visible: true
    dapRightPanel.initialItem: emptyRightPanel

    Component.onCompleted:
    {
        console.log("[KTT]", "onCompleted")
//        logicMainApp.requestToService("DapCertificateManagerCommands", 1)
//        logicMainApp.requestToService("DapGetListTokensCommand","")
//        ordersModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        console.log("[KTT]", "onDestruction")
        //ordersModule.statusProcessing = false
    }


}
