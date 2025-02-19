import QtQuick 2.4
import "qrc:/"
import "../../"
import "../controls"
import "Parts"

DapPage
{
    id: diagnosticTab

    property alias topPanel: topPanel

    dapHeader.initialItem: DapDiagnosticTopPanel{id: topPanel}
    dapScreen.initialItem: DapDiagnosticScreen{}

    dapRightPanelFrame.background: Item{}
    dapRightPanel.initialItem: DapDiagnosticRightPanel{id: rightPanel}


    Component.onCompleted:
    {
        console.log("Diagnostic tab open")
        var jsonDocument = JSON.parse(diagnosticsModule.getDiagData())
        diagnosticDataModel.clear();
        diagnosticDataModel.append(jsonDocument);
    }

    Component.onDestruction:
    {
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

    Connections{
        target: diagnosticsModule
        function onSignalDiagnosticData(diagnosticData){
            var jsonDocument = JSON.parse(diagnosticData)
            diagnosticDataModel.clear();
            diagnosticDataModel.append(jsonDocument);
        }
    }
}
