import QtQuick 2.4
import "qrc:/"
import "../../"
import "../controls"

DapPage
{
    id: diagnosticTab

    Component{id: emptyRightPanel; Item{}}

    dapHeader.initialItem: DapTopPanel{}
    dapScreen.initialItem: DapDiagnosticScreen{}

    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel


    Component.onCompleted:
    {
        console.log("Diagnostic tab open")
    }

    Component.onDestruction:
    {
        console.log("Diagnostic tab close")
    }
}
