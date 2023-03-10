import QtQuick 2.4
import "qrc:/"
import "../../"
import "../controls"
import "Parts"

DapPage
{
    id: diagnosticTab

    property alias topPanel: topPanel

    property bool checkSysUptime:  false
    property bool checkDashUptime: false
    property bool checkMemUptime:  false
    property bool checkMemFUptime: false

    Component{id: emptyRightPanel; Rectangle{}}

    dapHeader.initialItem: DapDiagnosticTopPanel{id: topPanel}
    dapScreen.initialItem: DapDiagnosticScreen{}

//    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel


    Component.onCompleted:
    {
        console.log("Diagnostic tab open")
    }

    Component.onDestruction:
    {
//        popupInfo.show(false)
        console.log("Diagnostic tab close")
    }

    PopupInfoPanel{
        id: popupInfo
    }

    Connections{
        target: topPanel
        function onShowInfo(flag){
            popupInfo.show(flag)

        }
    }
}
