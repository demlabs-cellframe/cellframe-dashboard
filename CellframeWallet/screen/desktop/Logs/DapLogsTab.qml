import QtQuick 2.4
import "qrc:/"
import "../../"
import "../controls"

DapPage
{
    property alias exportPopup: exportPopup

    id: logsTab

    ///Log window model.
    ListModel
    {
        id: dapLogsModel
    }

    DapExportPopup{
        id: exportPopup
    }

//    dapLogsModel.append({"type": arrLogString[2],
//                         "info": info,
//                         "file": arrLogString[3],
//                         "time": TimeFunction.getTime(stringTime),
//                         "date": TimeFunction.getDay(stringTime, privateDate),
//                         "momentTime": stringTime});

/*    ListModel
    {
        id: dapLogsModel
        ListElement {
            type: "WRN"
            info: "Verificator: token ticker in burning tx"
            file: "dap_chain_net_stake_lock"
            time: "16:20:45"
            date: "04/19/23"
            momentTime: "04/19/23-11:53:01"
        }
        ListElement {
            type: "WRN"
            info: "Verificator: token ticker in burning tx"
            file: "dap_chain_net_stake_lock"
            time: "16:20:45"
            date: "04/19/23"
            momentTime: "04/19/23-11:53:01"
        }
        ListElement {
            type: "WRN"
            info: "Verificator: token ticker in burning tx"
            file: "dap_chain_net_stake_lock"
            time: "16:20:45"
            date: "04/19/23"
            momentTime: "04/19/23-11:53:01"
        }
        ListElement {
            type: "DBG"
            info: "Cache file 'C:\Users\Public\Documents/cellframe-node/cache/e0fee993-54b7-4cbb-be94-f633cc17853f.cache' already exists"
            file: "chain_net"
            time: "11:07:43"
            date: "04/21/23"
            momentTime: "04/21/23-11:07:43"
        }
        ListElement {
            type: "ATT"
            info: "Cache file 'C:\Users\Public\Documents/cellframe-node/cache/e0fee993-54b7-4cbb-be94-f633cc17853f.cache' already exists"
            file: "chain_net"
            time: "11:07:43"
            date: "06/07/23"
            momentTime: "04/21/23-11:07:43"
        }
    }*/

    dapHeader.initialItem: DapLogsTopPanel {}

    dapScreen.initialItem: DapLogsScreen {id: logScreen}

    dapRightPanel.initialItem: DapLogsRightPanel {}

//    Timer
//    {
//           id: updLogTimer
//           interval: 5000
//           repeat: true
//           onTriggered:
//           {
//               console.log("LOG TIMER TICK")
//               logicMainApp.requestToService("DapUpdateLogsCommand", "100");
//           }
//    }

    Component.onCompleted:
    {
        console.log("Log tab open")
//        logicMainApp.requestToService("DapUpdateLogsCommand", "100");
//        updLogTimer.start()
    }

//    Component.onDestruction:
//    {
////        console.log("Log tab close")
////        updLogTimer.stop()
//    }
}
